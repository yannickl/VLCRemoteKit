//
//  NSHTTPURLResponseMock.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import "NSHTTPURLResponseMock.h"

@implementation NSHTTPURLResponseMock

+ (instancetype)niceMockWithStatusCode:(NSInteger)statusCode {
    id responseStub = [OCMockObject niceMockForClass:[NSHTTPURLResponse class]];
    [[[responseStub stub] andReturnValue:OCMOCK_VALUE((NSInteger)statusCode)] statusCode];
    
    return responseStub;
}

@end
