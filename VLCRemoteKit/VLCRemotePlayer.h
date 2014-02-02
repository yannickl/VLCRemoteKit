/*
 * YLMoment.h
 *
 * Copyright 2014 Yannick Loriot.
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

#import <Foundation/Foundation.h>
#import "VLCClientProtocol.h"

/**
 * Facade to work with the remote VLC player.
 * When you update a property of the local object, the change is automatically
 * sent to the remote player.
 */
@interface VLCRemotePlayer : NSObject
@property (nonatomic, weak, readonly) id<VLCClientProtocol> client;
@property (nonatomic, readonly) double apiVersion;
@property (nonatomic, getter = isPaused) BOOL  paused;
@property (nonatomic, getter = isPlaying) BOOL playing;
@property (nonatomic, getter = isFullscreenMode) BOOL fullscreenMode;

#pragma mark - Creating and Initializing a Remote Client
/** @name Creating and Initializing a Remote Client */

- (id)initWithClient:(id<VLCClientProtocol>)client;
+ (instancetype)remotePlayerWithClient:(id<VLCClientProtocol>)client;

#pragma mark -

/**
 * @abstract Starts the playback for the item with a given identifier.
 * @param itemIdentifier An item identifier.
 * @since 1.0.0
 */
- (void)playItemWithId:(NSInteger)itemIdentifier;

/**
 * @abstract Stops the current playback.
 * @since 1.0.0
 */
- (void)stop;

/**
 * @abstract Toggles VLC in the fullscreen or the windowed mode.
 * @since 1.0.0
 */
- (void)toogleFullscreen;

/**
 * @abstract Toggles VLC in pause / playback.
 * @since 1.0.0
 */
- (void)tooglePause;

@end
