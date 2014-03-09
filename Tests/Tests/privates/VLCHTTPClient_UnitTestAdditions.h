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

#import "VLCHTTPClient.h"

NSString * const _kVRKURLPathStatus = @"/requests/status.json";

@interface VLCHTTPClient ()
@property (nonatomic, strong) NSURLSession   *urlSession;
@property (assign) VLCClientConnectionStatus connectionStatus;
@property (nonatomic, copy) void (^connectionStatusChangeBlock) (VLCClientConnectionStatus status);

#pragma mark - Private Methods

/** Creates and returns an URL components from a given command. */
- (NSURLComponents *)urlComponentsFromCommand:(VLCCommand *)command;
/** Creates and returns an HTTP request for a given commmand. */
- (NSURLRequest *)urlRequestWithCommand:(VLCCommand *)command;
/** Load and starts an HTTP GET task using a given, then calls a handler upon completion. */
- (void)performRequest:(NSURLRequest *)request completionHandler:(void (^) (NSData *data, NSError *error))completionHandler;

@end
