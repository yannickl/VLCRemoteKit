/*
 * VLCRemoteKit
 *
 * Copyright 2014-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "VLCRemotePlayer.h"
#import "VLCRemoteObject_Private.h"
#import "VLCCommand.h"

@implementation VLCRemotePlayer

#pragma mark - Accessing Player Properties
@dynamic playbackState;
@dynamic playing;
@dynamic fullscreen;
@dynamic volume;

- (VLCRemotePlayerPlaybackState)playbackState {
    NSString *state = [self.state objectForKey:@"state"];
    
    if ([state isEqualToString:@"paused"]) {
        return VLCRemotePlayerPlaybackStatePaused;
    }
    else if ([state isEqualToString:@"playing"]) {
        return VLCRemotePlayerPlaybackStatePlaying;
    }
    else {
        return VLCRemotePlayerPlaybackStateStopped;
    }
}

- (BOOL)isPlaying {
    return [self playbackState] == VLCRemotePlayerPlaybackStatePlaying;
}

- (BOOL)isFullscreen {
    return [[self.state objectForKey:@"fullscreen"] boolValue];
}

- (void)setFullscreen:(BOOL)fullscreen {
    if (fullscreen != [self isFullscreen]) {
        VLCCommand *toggleFullscreenCommand = [VLCCommand toggleFullscreenCommand];
        [self.client performCommand:toggleFullscreenCommand completionHandler:nil];
    }
}

- (float)volume {
    return MAX(([[self.state objectForKey:@"volume"] floatValue] / 256.0f), 0.0f);
}

- (void)setVolume:(float)volume {
    VLCCommand *volumeCommand = [VLCCommand volumeCommandWithValue:(256 * volume)];
    [self.client performCommand:volumeCommand completionHandler:nil];
}

#pragma mark - Accessing the Media Duration
@dynamic duration;
@dynamic currentTime;

- (NSTimeInterval)duration {
    return MAX([[self.state objectForKey:@"length"] doubleValue], 0);
}

- (NSTimeInterval)currentTime {
    NSTimeInterval duration = [self duration];
    return MIN(MAX([[self.state objectForKey:@"time"] doubleValue], 0), duration);
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime != [self currentTime]) {
        VLCCommand *seekCommand = [VLCCommand seekCommandWithTimePosition:currentTime];
        [self.client performCommand:seekCommand completionHandler:nil];
    }
}

#pragma mark - Accessing the Media Metadatas
@dynamic filename;

- (NSString *)filename {
    return [[[[self.state objectForKey:@"information"] objectForKey:@"category"] objectForKey:@"meta"] objectForKey:@"filename"];
}

#pragma mark - Configuring and Controlling Playback
@dynamic randomPlayback;
@dynamic loopingPlaylist;
@dynamic repeating;

- (BOOL)isRandomPlayback {
    return [[self.state objectForKey:@"random"] boolValue];
}

- (void)setRandomPlayback:(BOOL)randomPlayback {
    if ([self isRandomPlayback] != randomPlayback) {
        VLCCommand *toggleRandomPlaybackCommand = [VLCCommand toggleRandomPlayback];
        [self.client performCommand:toggleRandomPlaybackCommand completionHandler:nil];
    }
}

- (BOOL)isLoopingPlaylist {
    return [[self.state objectForKey:@"loop"] boolValue];
}

- (void)setLoopingPlaylist:(BOOL)loopingPlaylist {
    if ([self isLoopingPlaylist] != loopingPlaylist) {
        VLCCommand *toggleLoopCommand= [VLCCommand toggleLoopCommand];
        [self.client performCommand:toggleLoopCommand completionHandler:nil];
    }
}

- (BOOL)isRepeating {
    return [[self.state objectForKey:@"repeat"] boolValue];
}

- (void)setRepeating:(BOOL)repeating {
    if ([self isRepeating] != repeating) {
        VLCCommand *toggleRepeatCommand= [VLCCommand toggleRepeatCommand];
        [self.client performCommand:toggleRepeatCommand completionHandler:nil];
    }
}

- (void)next {
    VLCCommand *nextCommand= [VLCCommand nextCommand];
    [self.client performCommand:nextCommand completionHandler:nil];
}

- (void)play {
    if ([self playbackState] == VLCRemotePlayerPlaybackStatePaused) {
        [self togglePause];
    }
}

- (void)previous {
    VLCCommand *previousCommand= [VLCCommand previousCommand];
    [self.client performCommand:previousCommand completionHandler:nil];
}

- (void)playItemWithId:(NSInteger)itemIdentifier {
    VLCCommand *playCommand= [VLCCommand playCommandWithItemWithIdentifier:itemIdentifier];
    [self.client performCommand:playCommand completionHandler:nil];
}

- (void)pause {
    if ([self playbackState] == VLCRemotePlayerPlaybackStatePlaying) {
        [self togglePause];
    }
}

- (void)stop {
    VLCCommand *stopCommand = [VLCCommand stopCommand];
    [self.client performCommand:stopCommand completionHandler:nil];
}

- (void)togglePause {
    VLCCommand *togglePauseCommand = [VLCCommand togglePauseCommand];
    [self.client performCommand:togglePauseCommand completionHandler:nil];
}

@end
