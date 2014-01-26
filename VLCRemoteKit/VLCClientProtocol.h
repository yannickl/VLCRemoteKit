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

@class VLCRemoteStatus;

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
 */
- (void)client:(id)client reachabilityDidChange:(NSInteger)status;

/**
 * @abstract Tells the delegate that the status is changed.
 * @param client A client object informing the delegate about the new status.
 * @param status The new status updated.
 */
- (void)client:(id)client didUpdateStatus:(VLCRemoteStatus *)status;
                          
@end

/**
 * The VLCClientProtocol is an interface which unifies the clients (HTTP,
 * telnet, etc.).
 */
@protocol VLCClientProtocol <NSObject>
/** The object that acts as the delegate of the receiving client. */
@property (nonatomic, weak) id<VLCClientDelegate> delegate;
/** Returns true whether the client is connected to the server endpoints. */
@property (nonatomic, readonly, getter = isConnected) BOOL connected;

/**
 * Start listening to the remote VLC.
 */
- (void)connect;

/**
 * Stops listening to the remote VLC.
 */
- (void)disconnect;

@end
