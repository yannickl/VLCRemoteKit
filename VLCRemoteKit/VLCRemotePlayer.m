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

@interface VLCRemotePlayer ()
/** The reference to a client to communicate with the remote VLC. */
@property (nonatomic, weak) id<VLCClientProtocol> client;

@end

@implementation VLCRemotePlayer
@dynamic paused;
@dynamic playing;
@dynamic fullscreen;

#pragma mark - Accessing Player Properties

- (BOOL)isPaused {
    if (self.state) {
        return [[self.state objectForKey:@"state"] isEqualToString:@"paused"];
    }
    return NO;
}

- (void)setPaused:(BOOL)paused {
    if (self.state) {
        if (paused != [self isPaused]) {
            VLCCommand *tooglePauseCommand = [VLCCommand tooglePauseCommand];
            [self.client performCommand:tooglePauseCommand completionHandler:nil];
        }
    }
}

- (BOOL)isPlaying {
    if (self.state) {
        return [[self.state objectForKey:@"state"] isEqualToString:@"playing"];
    }
    return NO;
}

- (BOOL)isFullscreen {
    if (self.state) {
        return [[self.state objectForKey:@"fullscreen"] boolValue];
    }
    return NO;
}

- (void)setFullscreen:(BOOL)fullscreen {
    if (self.state && fullscreen != [self isFullscreen]) {
        VLCCommand *toogleFullscreenCommand = [VLCCommand toogleFullscreenCommand];
        [self.client performCommand:toogleFullscreenCommand completionHandler:nil];
    }
}

#pragma mark - Accessing the Media Duration

#pragma mark - VLCCommand Protocol Methods

- (void)playItemWithId:(NSInteger)itemIdentifier {
    if (self.client) {
        
    }
}

- (void)tooglePause {
    if (self.client) {
        VLCCommand *tooglePauseCommand = [VLCCommand tooglePauseCommand];
        [self.client performCommand:tooglePauseCommand completionHandler:nil];
    }
}

- (void)stop {
    if (self.client) {
        
    }
}

- (void)toogleFullscreen {
    if (self.client) {
        VLCCommand *toogleFullscreenCommand = [VLCCommand toogleFullscreenCommand];
        [self.client performCommand:toogleFullscreenCommand completionHandler:nil];
    }
}

@end
