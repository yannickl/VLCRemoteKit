//
//  VLCTestObserver.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 08/03/14.
//
//

#import <XCTest/XCTest.h>

@interface VLCTestObserver : XCTestObserver

@end

@implementation VLCTestObserver

#ifdef _IPHONE_OS_VERSION_MAX_ALLOWED
- (void)stopObserving {
    [super stopObserving];

    extern void __gcov_flush(void);
    __gcov_flush();
}
#endif

@end
