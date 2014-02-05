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
#import <OCMock/OCMock.h>

/**
 * Convenience class to create NSURLSessionNiceMock mocks.
 */
@interface NSURLSessionNiceMock : OCMockObject

#pragma mark - Main

/** 
 * @abstract Creates and returns an NSURLSession mock with the
 * `dataTaskWithRequest:completionHandler:` method stub.
 * @param request The request used to perform the task.
 * @param completionHandler The completion handler to perform 
 * when the task is completed.
 * @param data The data returned to the given completion handler
 * when the task is completed.
 * @param response The response returned to the given completion
 * handler when the task is completed.
 * @param error The error returned to the given completion 
 * handler when the task is completed.
 */
+ (instancetype)mockWithRequest:(id)request completionHandler:(id)completionHandler returnedData:(NSData *)data returnedResponse:(NSURLResponse *)response returnedError:(NSError *)error;

#pragma mark - Specific

/**
 * @abstract Convenience methods which creates and returns a
 * mock which accepts any requests and completion handlers
 * corresponding to a given HTTP status code.
 * @param statusCode An HTTP status code.
 */
+ (instancetype)mockWithReturnedStatusCode:(NSInteger)statusCode;

@end
