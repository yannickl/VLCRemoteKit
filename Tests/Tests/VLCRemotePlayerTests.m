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
#import "VLCRemoteKit.h"

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
    _remotePlayer = [VLCRemotePlayer remoteWithVLCClient:_clientMock];
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
    [[[_clientMock stub] andDo:^(NSInvocation *invocation) {
        // The VLCCommand
        __autoreleasing VLCCommand *volumeCommand;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be the command
        [invocation getArgument:&volumeCommand atIndex:2];
        
        // Set the volume
        _remotePlayer.state = @{ @"volume": [volumeCommand.params objectForKey:@"val"] };
    }] performCommand:[OCMArg any] completionHandler:nil];
    
    _remotePlayer.volume = 0.0f;
    expect(_remotePlayer.volume).to.equal(0.0f);
    
    _remotePlayer.volume = 1.0f;
    expect(_remotePlayer.volume).to.equal(1.0f);
    
    _remotePlayer.volume = 2.0f;
    expect(_remotePlayer.volume).to.equal(2.0f);
}

#pragma mark Accessing the Media Duration

- (void)testGetDuration {
    expect(_remotePlayer.duration).to.equal(0);
    
    _remotePlayer.state = @{ @"length": @(0) };
    expect(_remotePlayer.duration).to.equal(0);
    
    _remotePlayer.state = @{ @"length": @(1230) };
    expect(_remotePlayer.duration).to.equal(1230);
    
    _remotePlayer.state = @{ @"length": @(-1) };
    expect(_remotePlayer.duration).to.equal(0);
}

- (void)testGetCurrentTime {
    expect(_remotePlayer.currentTime).to.equal(0);
    
    _remotePlayer.state = @{ @"time": @(0) };
    expect(_remotePlayer.currentTime).to.equal(0);
    
    _remotePlayer.state = @{ @"time": @(12) };
    expect(_remotePlayer.currentTime).to.equal(0);
    
    _remotePlayer.state = @{ @"time": @(12), @"length": @(1230) };
    expect(_remotePlayer.currentTime).to.equal(12);
    
    _remotePlayer.state = @{ @"time": @(1230), @"length": @(1230) };
    expect(_remotePlayer.currentTime).to.equal(1230);
    
    _remotePlayer.state = @{ @"time": @(1500), @"length": @(1230) };
    expect(_remotePlayer.currentTime).to.equal(1230);
}

- (void)testSetCurrentTime {
    [[[_clientMock stub] andDo:^(NSInvocation *invocation) {
        // The VLCCommand
        __autoreleasing VLCCommand *seekCommand;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be the command
        [invocation getArgument:&seekCommand atIndex:2];
        
        // Set the current time
        NSNumber *seekValue = [seekCommand.params objectForKey:@"val"];
        _remotePlayer.state = @{ @"time": seekValue, @"length": seekValue };
    }] performCommand:[OCMArg any] completionHandler:nil];
    
    _remotePlayer.currentTime = 0;
    expect(_remotePlayer.currentTime).to.equal(0.0f);
    
    _remotePlayer.currentTime = 1234;
    expect(_remotePlayer.currentTime).to.equal(1234);
}

#pragma mark - Accessing the Media Metadatas

- (void)testGetFilename {
    expect(_remotePlayer.filename).to.equal(nil);
    
    _remotePlayer.state = @{ @"information": @{} };
    expect(_remotePlayer.filename).to.equal(nil);
    
    _remotePlayer.state = @{ @"information": @"wrong params" };
    XCTAssertThrows(_remotePlayer.filename);
    
    _remotePlayer.state = @{ @"information": @{ @"category": @{ @"meta": @{ @"filename": @"matrix" } } } };
    expect(_remotePlayer.filename).to.equal(@"matrix");
}

#pragma mark - Configuring and Controlling Playback

- (void)testIsRandomPlayback {
    expect(_remotePlayer.randomPlayback).to.beFalsy();
    
    _remotePlayer.state = @{ @"random": @(NO) };
    expect(_remotePlayer.randomPlayback).to.beFalsy();
    
    _remotePlayer.state = @{ @"random": @(YES) };
    expect(_remotePlayer.randomPlayback).to.beTruthy();
}

- (void)testSetRandomPlayback {
    [[[_clientMock stub] andDo:^(NSInvocation *invocation) {
        // The VLCCommand
        __autoreleasing VLCCommand *toogleRandomPlaybackCommand;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be the command
        [invocation getArgument:&toogleRandomPlaybackCommand atIndex:2];
        
        // Toogle the randomPlayback
        if (_remotePlayer.randomPlayback) {
            _remotePlayer.state = @{ @"random": @"false" };
        }
        else {
            _remotePlayer.state = @{ @"random": @"true" };
        }
    }] performCommand:[OCMArg any] completionHandler:nil];
    
    _remotePlayer.state          = @{ @"random": @(NO) };
    _remotePlayer.randomPlayback = YES;
    expect(_remotePlayer.randomPlayback).to.beTruthy();
    
    _remotePlayer.randomPlayback = NO;
    expect(_remotePlayer.randomPlayback).to.beFalsy();
}

- (void)testIsLoopingPlaylist {
    expect(_remotePlayer.loopingPlaylist).to.beFalsy();
    
    _remotePlayer.state = @{ @"loop": @(NO) };
    expect(_remotePlayer.loopingPlaylist).to.beFalsy();
    
    _remotePlayer.state = @{ @"loop": @(YES) };
    expect(_remotePlayer.loopingPlaylist).to.beTruthy();
}

- (void)testSetLoopingPlaylist {
    [[[_clientMock stub] andDo:^(NSInvocation *invocation) {
        // The VLCCommand
        __autoreleasing VLCCommand *toggleLoopCommand;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be the command
        [invocation getArgument:&toggleLoopCommand atIndex:2];
        
        // Toogle the randomPlayback
        if (_remotePlayer.loopingPlaylist) {
            _remotePlayer.state = @{ @"loop": @"false" };
        }
        else {
            _remotePlayer.state = @{ @"loop": @"true" };
        }
    }] performCommand:[OCMArg any] completionHandler:nil];
    
    _remotePlayer.state           = @{ @"loop": @(NO) };
    _remotePlayer.loopingPlaylist = YES;
    expect(_remotePlayer.loopingPlaylist).to.beTruthy();
    
    _remotePlayer.loopingPlaylist = NO;
    expect(_remotePlayer.loopingPlaylist).to.beFalsy();
}

@end
