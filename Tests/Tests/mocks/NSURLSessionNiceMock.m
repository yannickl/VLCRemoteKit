//
// NSURLSessionNiceMock.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

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
