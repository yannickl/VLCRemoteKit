//
//  NSHTTPURLResponseMock.h
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

@interface NSHTTPURLResponseMock : OCMockObject

/**
 * Creates and returns an NSHTTPURLResponse mock with the
 * given status code.
 */
+ (instancetype)niceMockWithStatusCode:(NSInteger)statusCode;

@end
