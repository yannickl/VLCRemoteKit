//
//  NSHTTPURLResponseNiceMock.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import "NSHTTPURLResponseNiceMock.h"

@implementation NSHTTPURLResponseNiceMock

+ (instancetype)mockWithStatusCode:(NSInteger)statusCode {
    id responseStub = [OCMockObject niceMockForClass:[NSHTTPURLResponse class]];
    [[[responseStub stub] andReturnValue:OCMOCK_VALUE((NSInteger)statusCode)] statusCode];
    
    return responseStub;
}

@end
