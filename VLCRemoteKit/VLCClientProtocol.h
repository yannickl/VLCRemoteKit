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

@class VLCCommand;
@class VLCRemotePlayer;
@class VLCRemotePlaylist;

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

/**
 * The delegate of an object which implements the VLCClientProtocol should 
 * adopt the VLCClientDelegate protocol. Optional methods of the protocol allow
 * the delegate to be notified about the connection status changes.
 */
@protocol VLCClientDelegate <NSObject>

@optional

/**
 * @abstract Tells the delegate that the connection status with the remote VLC
 * did changed.
 * @param client A client object informing the delegate about the new connection
 * status.
 * @param status The connection status.
 * @since 1.0.0
 */
- (void)client:(id)client connectionStatusDidChanged:(VLCClientConnectionStatus)status;
                          
@end

/**
 * The VLCClientProtocol is an interface which unifies the clients for each
 * supported protocol (HTTP, telnet, etc.). A client can connect to an endpoint,
 * disconnect from the server, listening to network events (e.g. losing the 
 * connection), and performs the VLC commands.
 */
@protocol VLCClientProtocol <NSObject>

#pragma mark - Managing the Connection Status
/** @name Managing the Connection Status */

/**
 * @abstract Returns the connection status.
 * @since 1.0.0
 */
- (VLCClientConnectionStatus)connectionStatus;

/**
 * @abstract Set a block to be notified when a connection status change.
 * @param connectionBlock The block handler to call when a connection event
 * occured.
 * @discussion When you set the change block, you'll be notified for future
 * connection status change only. You will not receive the current connection
 * status, or the older changes.
 * @since 1.0.0
 */
- (void)setConnectionStatusChangeBlock:(void (^) (VLCClientConnectionStatus status))connectionBlock;

/**
 * @abstract The object that acts as the delegate of the receiving client.
 * @since 1.0.0
 */
@property (nonatomic, weak) id<VLCClientDelegate> delegate;

#pragma mark - Getting the Remote Objects
/** @name Getting the Remote Objects */

/**
 * @abstract Returns the remote player object associated to the client.
 * @since 1.0.0
 */
- (VLCRemotePlayer *)player;

/**
 * @abstract Returns the remote playlist object associated to the client.
 * @since 1.0.0
 */
- (VLCRemotePlaylist *)playlist;


#pragma mark - Communicating With VLC
/** @name Communicating With VLC */

/**
 * @abstract Connect the client to the remote VLC.
 * @param completionHandler The completion handler to call when the connection
 * did completed. This handler is executed on a delegate queue.
 * @discussion Once the method called, the client will try to connect to the
 * endpoint until the `disconnectWithCompletionHandler:` method will be called.
 * It means that if the remote endpoint is unreachable for example, the client
 * will not be disconnected automatically.
 * @since 1.0.0
 */
- (void)connectWithCompletionHandler:(void (^)(NSData *data, NSError *error))completionHandler;

/**
 * @abstract Disconnect the client.
 * @param completionHandler The completion handler to call when the
 * disconnection did completed. This handler is executed on a delegate queue.
 * @since 1.0.0
 */
- (void)disconnectWithCompletionHandler:(void (^) (NSError *error))completionHandler;

/** 
 * @abstract Send and executes a command to the remote VLC using the client 
 * communication protocol.
 * @param command The command send to the remote VLC.
 * @param completionHandler The completion handler to call when the connection
 * did completed. This handler is executed on a delegate queue.
 * @since 1.0.0
 */
- (void)performCommand:(VLCCommand *)command completionHandler:(void (^) (NSData *data, NSError *error))completionHandler;

@end
