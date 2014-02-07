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

#import "VLCClientProtocol.h"

/** The API version supported by the client. */
extern double const kVLCHTTPClientSupportedAPIVersion;

/**
 * The HTTP client communicate with the remote VLC over the HTTP protocol.
 *
 * By nature the HTTP is stateless, so it means we can not be notified when a
 * event occured (for example the progression state of the video). So we need
 * to pull the server every x seconds and check whether something changed.
 */
@interface VLCHTTPClient : NSObject <VLCClientProtocol>

#pragma mark - Creating and Initializing HTTP Clients
/** @name Creating and Initializing HTTP Clients */

/**
 * @abstract Initializes an HTTP client using an hostname, a port, a username
 * and a password.
 * @param hostname An hostname of the machine where the VLC is running.
 * @param port A port of the machine where the VLC is available (usually the 
 * port 8080).
 * @param username A username to connect to VLC.
 * @param password A password which correspond to the one configured in VLC.
 * @since 1.0.0
 */
- (id)initWithHostname:(NSString *)hostname port:(NSInteger)port username:(NSString *)username password:(NSString *)password;

/**
 * @abstract Creates an HTTP client using an hostname, a port, a username and
 * a password.
 * @param hostname An hostname of the machine where the VLC is running.
 * @param port A port of the machine where the VLC is available (usually the 
 * port 8080).
 * @param username A username to connect to VLC.
 * @param password A password which correspond to the one configured in VLC.
 * @since 1.0.0
 */
+ (instancetype)clientWithHostname:(NSString *)hostname port:(NSInteger)port username:(NSString *)username password:(NSString *)password;

#pragma mark - Managing the Delegate
/** @name Managing the Delegate */

/** The object that acts as the delegate of the receiving client. */
@property (nonatomic, weak) id<VLCClientDelegate> delegate;

@end
