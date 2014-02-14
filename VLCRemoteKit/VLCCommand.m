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

#import "VLCCommand.h"

@implementation VLCCommand

#pragma mark - Creating and Inializing Commands

- (id)initWithName:(VLCCommandName)name params:(NSDictionary *)params {
    if ((self = [super init])) {
        _name   = name;
        _params = params;
    }
    return self;
}

+ (instancetype)commandWithName:(VLCCommandName)name params:(NSDictionary *)params {
    return [[self alloc] initWithName:name params:params];
}

#pragma mark - Convenience Constructors

+ (instancetype)statusCommand {
    return [[self alloc] initWithName:VLCCommandNameStatus params:nil];
}

+ (instancetype)seekCommandWithTimePosition:(NSTimeInterval)timePosition {
    return [[self alloc] initWithName:VLCCommandNameSeek params:@{ @"val": @((NSInteger)timePosition) }];
}

+ (instancetype)toggleFullscreenCommand {
    return [[self alloc] initWithName:VLCCommandNameToggleFullscreen params:nil];
}

+ (instancetype)toggleLoopCommand {
    return [[self alloc] initWithName:VLCCommandNameToggleLoop params:nil];
}

+ (instancetype)togglePauseCommand {
    return [[self alloc] initWithName:VLCCommandNameTogglePause params:nil];
}

+ (instancetype)toggleRandomPlayback {
    return [[self alloc] initWithName:VLCCommandNameToggleRandomPlayback params:nil];
}

+ (instancetype)toggleRepeatCommand {
    return [[self alloc] initWithName:VLCCommandNameToggleRepeat params:nil];
}

+ (instancetype)stopCommand {
    return [[self alloc] initWithName:VLCCommandNameStop params:nil];
}

+ (instancetype)volumeCommandWithValue:(NSInteger)volume {
    return [[self alloc] initWithName:VLCCommandNameVolume params:@{ @"val": @(volume) }];
}

@end
