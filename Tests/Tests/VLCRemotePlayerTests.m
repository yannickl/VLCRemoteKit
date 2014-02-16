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

#import <XCTest/XCTest.h>
#import <VLCRemoteKit/VLCRemoteKit.h>

#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "FBTestBlocker.h"

#import "VLCRemoteObject_Private.h"

@interface VLCRemotePlayerTests : XCTestCase
@property (nonatomic, strong) id              clientMock;
@property (nonatomic, strong) VLCRemotePlayer *remotePlayer;

@end

@implementation VLCRemotePlayerTests

- (void)setUp {
    [super setUp];

    _clientMock   = [OCMockObject niceMockForProtocol:@protocol(VLCClientProtocol)];
    _remotePlayer = [VLCRemotePlayer remoteWithClient:_clientMock];
}

- (void)tearDown {
    self.clientMock   = nil;
    self.remotePlayer = nil;
    
    [super tearDown];
}

#pragma mark - Tests

#pragma mark Accessing Player Properties

- (void)testGetPlaybackState {
    _remotePlayer.state = @{ @"state": @"paused" };
    expect(_remotePlayer.playbackState).to.equal(VLCRemotePlayerPlaybackStatePaused);
    
    _remotePlayer.state = @{ @"state": @"playing" };
    expect(_remotePlayer.playbackState).to.equal(VLCRemotePlayerPlaybackStatePlaying);
    
    _remotePlayer.state = @{ @"state": @"stopped" };
    expect(_remotePlayer.playbackState).to.equal(VLCRemotePlayerPlaybackStateStopped);
}

- (void)testIsPlaying {
    _remotePlayer.state = @{ @"state": @"paused" };
    expect(_remotePlayer.playing).to.beFalsy();
    
    _remotePlayer.state = @{ @"state": @"playing" };
    expect(_remotePlayer.playing).to.beTruthy();
    
    _remotePlayer.state = @{ @"state": @"stopped" };
    expect(_remotePlayer.playing).to.beFalsy();
}

- (void)testIsFullscreen {
    _remotePlayer.state = @{ @"fullscreen": @"false" };
    expect(_remotePlayer.fullscreen).to.beFalsy();
    
    _remotePlayer.state = @{ @"fullscreen": @"true" };
    expect(_remotePlayer.fullscreen).to.beTruthy();
}

- (void)testSetFullscreen {
    [[[_clientMock stub] andDo:^(NSInvocation *invocation) {
        // The VLCCommand
        __autoreleasing VLCCommand *fullscreenCommand;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be the command
        [invocation getArgument:&fullscreenCommand atIndex:2];
        
        // Toogle the fullscreen
        if (_remotePlayer.fullscreen) {
            _remotePlayer.state = @{ @"fullscreen": @"false" };
        }
        else {
            _remotePlayer.state = @{ @"fullscreen": @"true" };
        }
    }] performCommand:[OCMArg any] completionHandler:nil];
    
    _remotePlayer.state      = @{ @"fullscreen": @"false" };
    expect(_remotePlayer.fullscreen).to.beFalsy();
    
    _remotePlayer.fullscreen = YES;
    expect(_remotePlayer.fullscreen).to.beTruthy();
    
    _remotePlayer.fullscreen = YES;
    expect(_remotePlayer.fullscreen).to.beTruthy();
    
    _remotePlayer.fullscreen = NO;
    expect(_remotePlayer.fullscreen).to.beFalsy();
}

- (void)testGetVolume {
    _remotePlayer.state = @{ @"volume": @(256) };
    expect(_remotePlayer.volume).to.equal(1.0f);
    
    _remotePlayer.state = @{ @"volume": @(0) };
    expect(_remotePlayer.volume).to.equal(0.0f);
    
    _remotePlayer.state = @{ @"volume": @(-24) };
    expect(_remotePlayer.volume).to.equal(0.0f);
}

- (void)testSetVolume {
    
}

#pragma mark Accessing the Media Duration

@end
