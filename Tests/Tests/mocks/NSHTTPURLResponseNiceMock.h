//
//  NSHTTPURLResponseNiceMock.h
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import <Foundation/Foundation.h>
#import <OCMock/OCMock.h>

/**
 * Convenience class to create NSHTTPURLResponse mocks.
 */
@interface NSHTTPURLResponseNiceMock : OCMockObject

/**
 * @abstract Creates and returns an NSHTTPURLResponse mock with the
 * given status code as stub.
 * @param statusCode An HTTP status code.
 */
+ (instancetype)mockWithStatusCode:(NSInteger)statusCode;

@end
