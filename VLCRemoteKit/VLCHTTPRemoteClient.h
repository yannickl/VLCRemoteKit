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

#import "VLCCommandProtocol.h"
#import "VLCRemoteClientProtocol.h"

/** The API version supported by the client. */
extern double const kVRKHTTPClientAPIVersion;
/** The recommended time interval to use to pull the status. */
extern NSTimeInterval const kVRKDefaultTimeInterval;

@interface VLCHTTPRemoteClient : NSObject <VLCCommandProtocol, VLCRemoteClientProtocol>

#pragma mark - Creating and Initializing HTTP Clients

/**
 * Initializes an HTTP client using an hostname, a port and a password.
 * @param hostname the hostname of the machine where the VLC is running.
 * @param port the port of the machine where the VLC is available (usually the port 8080).
 * @param password the password configured in VLC.
 * @version 1.0.0
 */
- (id)initWithHostname:(NSString *)hostname port:(NSInteger)port password:(NSString *)password;
- (id)initWithURL:(NSURL *)url password:(NSString *)password;

#pragma mark - Public Methods

@end
