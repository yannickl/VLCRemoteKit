//
//  NSURLSessionMock.h
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

@interface NSURLSessionMock : OCMockObject

/** 
 * Creates and returns an NSURLSession mock with the
 * `dataTaskWithRequest:completionHandler:` method stub.
 */
+ (instancetype)niceMockWithStatusCode:(NSInteger)statusCode;

@end
