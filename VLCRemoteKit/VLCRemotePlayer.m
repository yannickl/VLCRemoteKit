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

- (VLCRemotePlayerPlaybackState)playbackState {
    NSString *state = [self.state objectForKey:@"state"];
    if ([state isEqualToString:@"stopped"]) {
        return VLCRemotePlayerPlaybackStateStopped;
    }
    else if ([state isEqualToString:@"playing"]) {
        return VLCRemotePlayerPlaybackStatePlaying;
    }
    else {
        return VLCRemotePlayerPlaybackStatePaused;
    }
}

- (BOOL)isPaused {
    return [[self.state objectForKey:@"state"] isEqualToString:@"paused"];
}

- (void)setPaused:(BOOL)paused {
    if (paused != [self isPaused]) {
        VLCCommand *tooglePauseCommand = [VLCCommand tooglePauseCommand];
        [self.client performCommand:tooglePauseCommand completionHandler:nil];
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
        VLCCommand *toogleFullscreenCommand = [VLCCommand toogleFullscreenCommand];
        [self.client performCommand:toogleFullscreenCommand completionHandler:nil];
    }
}

#pragma mark - Accessing the Media Duration
@dynamic duration;
@dynamic currentTime;

- (NSTimeInterval)duration {
    return [[self.state objectForKey:@"length"] doubleValue];
}

- (NSTimeInterval)currentTime {
    return [[self.state objectForKey:@"time"] doubleValue];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime {
    if (currentTime != [self currentTime]) {
        VLCCommand *seekCommand = [VLCCommand seekCommandWithTimePosition:currentTime];
        [self.client performCommand:seekCommand completionHandler:nil];
    }
}

#pragma mark - Configuring and Controlling Playback

- (void)play {
    if ([self playbackState] == VLCRemotePlayerPlaybackStatePaused) {
        [self tooglePause];
    }
}

- (void)pause {
    if ([self playbackState] == VLCRemotePlayerPlaybackStatePlaying) {
        [self tooglePause];
    }
}

- (void)stop {
    VLCCommand *stopCommand = [VLCCommand stopCommand];
    [self.client performCommand:stopCommand completionHandler:nil];
}

- (void)tooglePause {
    VLCCommand *tooglePauseCommand = [VLCCommand tooglePauseCommand];
    [self.client performCommand:tooglePauseCommand completionHandler:nil];
}

#pragma mark - VLCCommand Protocol Methods

- (void)playItemWithId:(NSInteger)itemIdentifier {

}

@end
