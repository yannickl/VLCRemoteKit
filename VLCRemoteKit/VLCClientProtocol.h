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
typedef NS_ENUM(NSInteger, VLCClientConnectionStatus) {
    /** The client is disconnected. */
    VLCClientConnectionStatusDisconnected,
    /** The client is trying to connect to the VLC server. */
    VLCClientConnectionStatusConnecting,
    /** The client can't etablished a connection with the client. */
    VLCClientConnectionStatusUnreachable,
    /** The client is unauthorized to connect to the VLC server. */
    VLCClientConnectionStatusUnauthorized,
    /** The client is connected to the VLC server endpoints. */
    VLCClientConnectionStatusConnected
};

@class VLCRemotePlayer;

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
- (void)client:(id)client reachabilityStatusDidChange:(VLCClientConnectionStatus)status;

/**
 * @abstract Tells the delegate that the player status is changed.
 * @param client A client object informing the delegate about the new player
 * status.
 * @param status The new player status updated.
 * @version 1.0.0
 */
- (void)client:(id)client playerStatusDidChange:(VLCRemotePlayer *)status;
                          
@end

@class VLCCommand;

/**
 * The VLCClientProtocol is an interface which unifies the clients for each
 * supported protocol (HTTP, telnet, etc.). A client can connect to an endpoint,
 * disconnect from the server, listening to network events (e.g. losing the 
 * connection), and performs the VLC commands.
 */
@protocol VLCClientProtocol <NSObject>
/** The object that acts as the delegate of the receiving client. */
@property (nonatomic, weak) id<VLCClientDelegate> delegate;
/**
 * @abstract The connection status.
 * @version 1.0.0
 */
@property (readonly) VLCClientConnectionStatus connectionStatus;
/**
 * Whether auto reconnect is enabled or disabled.
 *
 * The default value is YES (enabled).
 *
 * Note: Altering this property will only affect future accidental disconnections.
 * For example, if autoReconnect was true, and you disable this property after an accidental disconnection,
 * this will not stop the current reconnect process.
 * In order to stop a current reconnect process use the stop method.
 *
 * Similarly, if autoReconnect was false, and you enable this property after an accidental disconnection,
 * this will not start a reconnect process.
 * In order to start a reconnect process use the manualStart method.
 **/
@property (nonatomic, assign) BOOL autoReconnect;

/**
 * @abstract Connect the client to the remote VLC.
 * @param completionHandler The completion handler to call when the connection
 * is complete. This handler is executed on the delegate queue.
 * @version 1.0.0
 */
- (void)connectWithCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler;

/**
 * @abstract Disconnect the client.
 * @param completionHandler The completion handler to call when the
 * deconnection is complete. This handler is executed on the delegate queue.
 * @version 1.0.0
 */
- (void)disconnectWithCompletionHandler:(void (^) (NSError *error))completionHandler;

- (void)setConnectionStatusChangeBlock:(void (^) (VLCClientConnectionStatus))connectionBlock;

/** 
 * @abstract 
 * @param command
 * @param completionHandler
 */
- (void)performCommand:(VLCCommand *)command completionHandler:(void (^) (NSData *data, NSError *error))completionHandler;

@end
