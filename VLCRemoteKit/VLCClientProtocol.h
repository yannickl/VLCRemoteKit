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

/**
 * The client's connection status.
 */
typedef NS_ENUM(NSInteger, VLCClientStatus) {
    /** The client can't etablished a connection with the client. */
    VLCClientStatusUnreachable,
    /** The client is unauthorized to connect to the VLC's server. */
    VLCClientStatusUnauthorized,
    /** The client is connected to the VLC's server endpoints. */
    VLCClientStatusConnected
};

@class VLCPlayerStatus;

/**
 * The delegate of an object which implements the VLCClientProtocol must adopt 
 * the VLCClientDelegate protocol. Optional methods of the protocol allow the
 * delegate to be notified about reachability changes or when a the VLC status
 * is updated.
 */
@protocol VLCClientDelegate <NSObject>

@optional

/**
 * @abstract Tells the delegate that the reachability with the remote VLC 
 * changed.
 * @param client A client object informing the delegate about the new status.
 * @version 1.0.0
 */
- (void)client:(id)client reachabilityStatusDidChange:(VLCClientStatus)status;

/**
 * @abstract Tells the delegate that the player status is changed.
 * @param client A client object informing the delegate about the new player
 * status.
 * @param status The new player status updated.
 * @version 1.0.0
 */
- (void)client:(id)client playerStatusDidChange:(VLCPlayerStatus *)status;
                          
@end

/**
 * The VLCClientProtocol is an interface which unifies the clients (HTTP,
 * telnet, etc.).
 */
@protocol VLCClientProtocol <NSObject>
/** The object that acts as the delegate of the receiving client. */
@property (nonatomic, weak) id<VLCClientDelegate> delegate;
/** The connection status. */
@property (nonatomic, readonly) VLCClientStatus status;

/**
 * @abstract Start listening to the remote VLC.
 * @version 1.0.0
 */
- (void)connect;

/**
 * @abstract Stops listening to the remote VLC.
 * @version 1.0.0
 */
- (void)disconnect;

@end
