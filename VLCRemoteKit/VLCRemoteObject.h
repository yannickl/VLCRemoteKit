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

#import <Foundation/Foundation.h>
#import "VLCClientProtocol.h"

/**
 * Base class to create remote objects.
 * A remote object is an abstraction to make the interaction with a remote
 * "object" (e.g. the player or the playlist) easier. It allows you to
 * manipulate VLC by working/modifying local objects like any other objects.
 */
@interface VLCRemoteObject : NSObject

#pragma mark - Creating and Initializing a Remote Object
/** @name Creating and Initializing a Remote Object */

/**
 * @abstract Initializes and returns a remote object with a given client serving
 * to communicate with the VLC.
 * @param client The receiver client.
 * @since 1.0.0
 */
- (id)initWithClient:(id<VLCClientProtocol>)client;

/**
 * @abstract Creates and returns a remote object with a given client serving to
 * communicate with the VLC.
 * @param client The receiver client.
 * @since 1.0.0
 */
+ (instancetype)remoteWithClient:(id<VLCClientProtocol>)client;

#pragma mark - Getting the Client
/** @name Getting the Client */

/**
 * @abstract The client used to perform the communication.
 * @since 1.0.0
 */
@property (nonatomic, weak, readonly) id<VLCClientProtocol> client;

@end
