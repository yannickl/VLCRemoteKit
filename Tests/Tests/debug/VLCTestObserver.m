//
//  VLCTestObserver.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 08/03/14.
//
//

#import <XCTest/XCTest.h>

extern void __gcov_flush(void);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface VLCTestObserver : XCTestObserver

@end
#pragma clang diagnostic pop

@implementation VLCTestObserver

#ifdef TARGET_OS_IPHONE
- (void)stopObserving {
    [super stopObserving];
    
    __gcov_flush();
}
#endif

@end