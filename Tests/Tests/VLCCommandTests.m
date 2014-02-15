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

@interface VLCCommandTests : XCTestCase
@end

@implementation VLCCommandTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Utils

- (void)expectCommand:(VLCCommand *)command hasName:(VLCCommandName)name params:(NSDictionary *)params {
    expect(command).toNot.beNil();
    expect(command.name).to.equal(name);
    
    if (params) {
        expect(command.params).notTo.beNil();
        for (id key in params) {
            expect([command.params objectForKey:key]).to.equal(params[key]);
        }
    }
    else {
        expect(command.params).to.beNil();
    }
}

#pragma mark - Tests

#pragma mark Creating and Inializing Commands

- (void)testInit {
    VLCCommand *command = [VLCCommand commandWithName:VLCCommandNameStatus params:nil];
    [self expectCommand:command hasName:VLCCommandNameStatus params:nil];
    
    NSDictionary *fooParams = @{ @"key": @"val"};
    VLCCommand *fooCommand  = [VLCCommand commandWithName:-1 params:fooParams];
    [self expectCommand:fooCommand hasName:-1 params:fooParams];
    expect(fooCommand.params).to.equal(fooParams);
}

#pragma mark Convenience Constructors

- (void)testNext {
    VLCCommand *nextCommand = [VLCCommand nextCommand];
    [self expectCommand:nextCommand hasName:VLCCommandNameNext params:nil];
}

- (void)testPlayItemWithIdentifier {
    VLCCommand *playCommand = [VLCCommand playCommandWithItemWithIdentifier:4];
    [self expectCommand:playCommand hasName:VLCCommandNamePlay params:@{ @"id": @(4) }];
}

- (void)testPrevious {
    VLCCommand *previousCommand = [VLCCommand previousCommand];
    [self expectCommand:previousCommand hasName:VLCCommandNamePrevious params:nil];
}

- (void)testSeek {
    VLCCommand *seekCommand = [VLCCommand seekCommandWithTimePosition:43];
    [self expectCommand:seekCommand hasName:VLCCommandNameSeek params:@{ @"val": @(43) }];
}

- (void)testStatus {
    VLCCommand *statusCommand = [VLCCommand statusCommand];
    [self expectCommand:statusCommand hasName:VLCCommandNameStatus params:nil];
}

- (void)testStop {
    VLCCommand *stopCommand = [VLCCommand stopCommand];
    [self expectCommand:stopCommand hasName:VLCCommandNameStop params:nil];
}

- (void)testToggleFullscreen {
    VLCCommand *toggleFullscreenCommand = [VLCCommand toggleFullscreenCommand];
    [self expectCommand:toggleFullscreenCommand hasName:VLCCommandNameToggleFullscreen params:nil];
}

- (void)testToggleLoop {
    VLCCommand *toggleLoopCommand = [VLCCommand toggleLoopCommand];
    [self expectCommand:toggleLoopCommand hasName:VLCCommandNameToggleLoop params:nil];
}

- (void)testTogglePause {
    VLCCommand *togglePauseCommand = [VLCCommand togglePauseCommand];
    [self expectCommand:togglePauseCommand hasName:VLCCommandNameTogglePause params:nil];
}

- (void)testToggleRandomPlayback {
    VLCCommand *toggleRandomPlaybackCommand = [VLCCommand toggleRandomPlayback];
    [self expectCommand:toggleRandomPlaybackCommand hasName:VLCCommandNameToggleRandomPlayback params:nil];
}

- (void)testToggleRepeat {
    VLCCommand *togglePauseCommand = [VLCCommand toggleRepeatCommand];
    [self expectCommand:togglePauseCommand hasName:VLCCommandNameToggleRepeat params:nil];
}

- (void)testVolume {
    VLCCommand *volumeCommand = [VLCCommand volumeCommandWithValue:58];
    [self expectCommand:volumeCommand hasName:VLCCommandNameVolume params:@{ @"val": @(58) }];
}

@end
