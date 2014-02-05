//
//  NSURLSessionNiceMock.h
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

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
