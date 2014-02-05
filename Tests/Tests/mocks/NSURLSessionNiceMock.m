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

#import "NSURLSessionNiceMock.h"
#import "NSHTTPURLResponseNiceMock.h"

@implementation NSURLSessionNiceMock

#pragma mark - Main

+ (instancetype)mockWithRequest:(id)request completionHandler:(id)completionHandler returnedData:(NSData *)data returnedResponse:(NSURLResponse *)response returnedError:(NSError *)error {
    
    // Creates the session stub
    id urlSessionMock = [OCMockObject niceMockForClass:[NSURLSession class]];
    [[[urlSessionMock stub] andDo:^(NSInvocation *invocation) {
        //the block we will invoke
        void (^handler)(NSData *data, NSURLResponse *response, NSError *error) = nil;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be dataTaskWithRequest, 3 is completionHandler (block)
        [invocation getArgument:&handler atIndex:3];
        
        // Invoke the completion handler block
        handler(data, response, error);
    }] dataTaskWithRequest:request completionHandler:completionHandler];
    
    return urlSessionMock;
}

#pragma mark - Specific

+ (instancetype)mockWithReturnedStatusCode:(NSInteger)statusCode {
    id requestMock           = [OCMArg any];
    id completionHandlerMock = [OCMArg any];
    id dataMock              = (statusCode <= 200 || statusCode < 300) ? [OCMockObject niceMockForClass:[NSData class]] : nil;
    id httpResponseMock      = [NSHTTPURLResponseNiceMock mockWithStatusCode:statusCode];
    id errorMock             = (statusCode < 0 || statusCode > 1000) ? [OCMockObject niceMockForClass:[NSError class]] : nil;
    
    return [self mockWithRequest:requestMock completionHandler:completionHandlerMock returnedData:dataMock returnedResponse:httpResponseMock returnedError:errorMock];
}

@end
