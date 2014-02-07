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

#import "VLCRemoteObject.h"
#import "VLCClientProtocol.h"

/**
 * Constants describing the state of the player's playback.
 */
typedef NS_ENUM(NSInteger, VLCRemotePlayerPlaybackState) {
    /** The player is stopped. */
    VLCRemotePlayerPlaybackStateStopped,
    /** The player is playing. */
    VLCRemotePlayerPlaybackStatePlaying,
    /** The player is paused. */
    VLCRemotePlayerPlaybackStatePaused
};

/**
 * The VLCRemotePlayer is a facade which facilitate the communication with the
 * VLC player.
 *
 * At a given moment, a VLCRemotePlayer represents the state of the remote VLC
 * player. You can modify its properties locally to propagate the changes to
 * the remote player.
 */
@interface VLCRemotePlayer : VLCRemoteObject

#pragma mark - Accessing Player Properties
/** @name Accessing Player Properties */

/**
 * @abstract The playback state of the player.
 * @discussion By default this property is equal to 
 * VLCRemotePlayerPlaybackStateStopped.
 * @since 1.0.0
 */
@property (nonatomic, readonly) VLCRemotePlayerPlaybackState playbackState;

@property (nonatomic, getter = isPaused) BOOL  paused;
@property (nonatomic, getter = isPlaying) BOOL playing;

/**
 * @abstract A Boolean that indicates whether the movie player is in 
 * full-screen mode.
 * @discussion This property is relevant in the video mode only.
 * @since 1.0.0
 */
@property (nonatomic, getter = isFullscreen) BOOL fullscreen;

#pragma mark - Accessing the Media Duration
/** @name Accessing the Media Duration */

/**
 * @abstract The duration of the media, measured in seconds.
 * @discussion If the duration of the movie is not known, the value 
 * in this property is 0.0.
 * @since 1.0.0
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 * @abstract The playback point, in seconds, within the timeline of 
 * the media associated with the player.
 * @discussion If the media is playing, currentTime is the offset of
 * the current playback position, measured in seconds from the start
 * of the media.
 * By setting this property you can seek to a specific point in a
 * media (audio, video, etc.) file or implement media fast-forward 
 * and rewind functions.
 * @since 1.0.0
 */
@property NSTimeInterval currentTime;

#pragma mark - Commands
/** @name Commands */

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
