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

/** Absolute URL path to the status of VLC. */
NSString * const kVRKURLPathStatus   = @"/requests/status.json";
/** Absolute URL path to the playlist of VLC. */
NSString * const kVRKURLPathPlaylist = @"/requests/playlist.json";

@interface VLCCommand ()
@property (nonatomic, assign) VLCCommandName name;
@property (nonatomic, strong) NSDictionary   *params;
@property (nonatomic, strong) NSString       *pathComponent;
@property (nonatomic, strong) NSString       *queryComponent;

@end

@implementation VLCCommand

#pragma mark - Creating and Inializing Commands

- (id)initWithName:(VLCCommandName)name params:(NSDictionary *)params {
    if ((self = [super init])) {
        self.name   = name;
        self.params = params;
      
        [self buildURLComponents];
    }
    return self;
}

+ (instancetype)commandWithName:(VLCCommandName)name params:(NSDictionary *)params {
    return [[self alloc] initWithName:name params:params];
}

#pragma mark - Convenience Constructors

+ (instancetype)nextCommand {
    return [[self alloc] initWithName:VLCCommandNameNext params:nil];
}

+ (instancetype)playCommandWithItemWithIdentifier:(NSInteger)itemIdentifier {
    NSDictionary *params = (itemIdentifier == -1) ? @{} : @{ @"id": @(itemIdentifier) };
    return [[self alloc] initWithName:VLCCommandNamePlay params:params];
}

+ (instancetype)previousCommand {
    return [[self alloc] initWithName:VLCCommandNamePrevious params:nil];
}

+ (instancetype)seekCommandWithTimePosition:(NSTimeInterval)timePosition {
    return [[self alloc] initWithName:VLCCommandNameSeek params:@{ @"val": @((NSInteger)timePosition) }];
}

+ (instancetype)statusCommand {
    return [[self alloc] initWithName:VLCCommandNameStatus params:nil];
}

+ (instancetype)stopCommand {
    return [[self alloc] initWithName:VLCCommandNameStop params:nil];
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

+ (instancetype)volumeCommandWithValue:(NSInteger)volume {
    return [[self alloc] initWithName:VLCCommandNameVolume params:@{ @"val": @(volume) }];
}

#pragma mark - Managing URL Components

- (void)buildURLComponents {
    switch (_name) {
        case VLCCommandNameNext:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_next";
            break;
        case VLCCommandNamePlay:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_play";
            break;
        case VLCCommandNamePrevious:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_previous";
            break;
        case VLCCommandNameSeek:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=seek";
            break;
        case VLCCommandNameStatus:
            _pathComponent = kVRKURLPathStatus;
            break;
        case VLCCommandNameStop:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_stop";
            break;
        case VLCCommandNameToggleFullscreen:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=fullscreen";
            break;
        case VLCCommandNameToggleLoop:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_loop";
            break;
        case VLCCommandNameTogglePause:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_pause";
            break;
        case VLCCommandNameToggleRandomPlayback:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_random";
            break;
        case VLCCommandNameToggleRepeat:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=pl_repeat";
            break;
        case VLCCommandNameVolume:
            _pathComponent  = kVRKURLPathStatus;
            _queryComponent = @"command=volume";
            break;
        default:
            return;
    }
    
    NSMutableString *additionalQuery = [NSMutableString string];
    for (NSString *key in _params) {
        [additionalQuery appendString:[NSString stringWithFormat:@"&%@=%@", key, _params[key]]];
    }
    if (additionalQuery.length > 0) {
        _queryComponent = [NSString stringWithFormat:@"%@%@", _queryComponent, additionalQuery];
    }
}

@end
