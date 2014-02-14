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

@interface VLCRemoteObjectTests : XCTestCase
@property (nonatomic, strong) VLCRemoteObject *remoteObject;

@end

@implementation VLCRemoteObjectTests

- (void)setUp {
    [super setUp];
    
    id clientMock = [OCMockObject niceMockForProtocol:@protocol(VLCRemoteProtocol)];
    _remoteObject = [VLCRemoteObject remoteWithClient:clientMock];
}

- (void)tearDown {
    _remoteObject = nil;

    [super tearDown];
}

#pragma mark - Tests

#pragma mark Creating and Initializing a Remote Client

- (void)testInitializationWithEmptyClient {
    XCTAssertThrows([[VLCRemoteObject alloc] initWithClient:nil], @"A remote object needs have a client to work");
}

- (void)testInitializationWithClient {
    id clientMock = [OCMockObject niceMockForProtocol:@protocol(VLCRemoteProtocol)];

    XCTAssertNoThrow([[VLCRemoteObject alloc] initWithClient:clientMock], @"A remote object must have a client");
}

- (void)testInitialState {
    expect(_remoteObject).toNot.beNil();
    expect(_remoteObject.stateHash).to.equal(0);
    XCTAssertNil(_remoteObject.state, @"The initial state must be unknown");
}

#pragma mark Updating the Internal State

- (void)testUpdateStateWithData {
    // Test with no data
    [_remoteObject updateStateWithData:nil];
    expect(_remoteObject.stateHash).to.equal(0);
    expect(_remoteObject.state).to.beNil();
    
    // Test with data, but not valid JSON
    [_remoteObject updateStateWithData:[NSData data]];
    expect(_remoteObject.stateHash).to.equal(0);
    expect(_remoteObject.state).to.beNil();
    
    // Test with a valid JSON
    NSData *data = [@"{}" dataUsingEncoding:NSUTF8StringEncoding];
    [_remoteObject updateStateWithData:data];
    expect(_remoteObject.stateHash).to.equal([data hash]);
    expect(_remoteObject.state).notTo.beNil();
}

- (void)testUpdateWithStateAndHash {
    // Test with no state
    [_remoteObject updateWithState:nil andHash:1];
    expect(_remoteObject.stateHash).to.equal(0);
    expect(_remoteObject.state).to.beNil();
    
    // Test with same hash
    [_remoteObject updateWithState:@{} andHash:0];
    expect(_remoteObject.stateHash).to.equal(0);
    expect(_remoteObject.state).to.beNil();
    
    // Test with new state and hash
    [_remoteObject updateWithState:@{} andHash:1];
    expect(_remoteObject.stateHash).to.equal(1);
    expect(_remoteObject.state).notTo.beNil();
}

#pragma mark Managing the Delegate

- (void)testDelegate {
    // Prepare the mocks
    id delegateMock = [OCMockObject niceMockForProtocol:@protocol(VLCRemoteDelegate)];
    id stateMock    = [OCMockObject niceMockForClass:[NSDictionary class]];
    
    // Setup the mocks
    _remoteObject.delegate = delegateMock;
    [_remoteObject updateWithState:stateMock andHash:1];
    
    // Check
    [[delegateMock expect] remoteObjectDidChanged:_remoteObject];
    [FBTestBlocker waitForVerifiedMock:delegateMock delay:0.1f];
    
    // If the state does not change
    [_remoteObject updateWithState:stateMock andHash:1];
    [[delegateMock reject] remoteObjectDidChanged:[OCMArg any]];
    [FBTestBlocker waitForVerifiedMock:delegateMock delay:0.1f];
    
    // If no state is passed
    [_remoteObject updateWithState:stateMock andHash:2];
    [[delegateMock reject] remoteObjectDidChanged:[OCMArg any]];
    [FBTestBlocker waitForVerifiedMock:delegateMock delay:0.1f];
    
    // If state changed
    [_remoteObject updateWithState:stateMock andHash:2];
    [[delegateMock reject] remoteObjectDidChanged:_remoteObject];
    [FBTestBlocker waitForVerifiedMock:delegateMock delay:0.1f];
}

@end
