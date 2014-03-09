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

#import "NSURLSessionNiceMock.h"
#import "NSHTTPURLResponseNiceMock.h"

#import "VLCHTTPClient_UnitTestAdditions.h"

#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "FBTestBlocker.h"

static NSString * const dummyHost = @"1.2.3.4";
static NSInteger const dummyPort  = 1111;

@interface VLCHTTPClientTests : XCTestCase
@end

@implementation VLCHTTPClientTests

#pragma mark - Private

#pragma mark Properties

- (void)testConnectionStatusUpdateViaDelegates {
    // Create the delegate
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    // Create the client
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.delegate       = mockDelegate;
    
    // Check that the connection status is disconnected
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusDisconnected);
    
    // Update the connection status with a new value
    httpClient.connectionStatus = VLCClientConnectionStatusConnecting;
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnecting];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    // Update the connection with the same value
    httpClient.connectionStatus = VLCClientConnectionStatusConnecting;
    [[mockDelegate reject] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnecting];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    // Update the connection with the same value
    httpClient.connectionStatus = VLCClientConnectionStatusConnecting;
    [[mockDelegate reject] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnecting];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    // Update the connection with a new value
    httpClient.connectionStatus = VLCClientConnectionStatusConnected;
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnected];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
}

- (void)testConnectionStatusUpdateViaBlocks {
    // Create the delegate
    id mockDelegate = [OCMockObject  niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    // Create the client
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    
    __block VLCClientConnectionStatus returnedStatus = httpClient.connectionStatus;
    [httpClient setConnectionStatusChangeBlock:^(VLCClientConnectionStatus status) {
        returnedStatus = status;
    }];
    
    // Check that the connection status is disconnected
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusDisconnected);
    
    FBTestBlocker *blocker = [[FBTestBlocker alloc] init];
    
    // Update the connection status with a new value
    httpClient.connectionStatus = VLCClientConnectionStatusConnecting;
    [blocker waitWithTimeout:0.1f];
    
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusConnecting);

    // Update the connection with the same value
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnecting];
    [blocker waitWithTimeout:0.1f];
    
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusConnecting);
    
    // Update the connection with a new value
    httpClient.connectionStatus = VLCClientConnectionStatusConnected;
    [blocker waitWithTimeout:0.1f];
    
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusConnected);
}

#pragma mark Methods

#pragma mark  URL Components From Commands

- (void)testURLComponentsFromNilCommand {
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    
    NSURLComponents *nilComponents = [httpClient urlComponentsFromCommand:nil];
    expect(nilComponents).to.beNil();
}

- (void)testURLComponentsFromDummyCommand {
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    
    VLCCommand *dummyCommand         = [VLCCommand commandWithName:-1 params:nil];
    NSURLComponents *dummyComponents = [httpClient urlComponentsFromCommand:dummyCommand];
    expect(dummyComponents).to.beNil();
}

- (void)testURLComponentsFromStatusCommand {
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    
    VLCCommand *statusCommand         = [VLCCommand statusCommand];
    NSURLComponents *statusComponents = [httpClient urlComponentsFromCommand:statusCommand];
    
    expect(statusComponents).toNot.beNil();
    expect(statusComponents.host).to.equal(dummyHost);
    expect(statusComponents.port).to.equal(dummyPort);
    expect(statusComponents.path).to.equal(_kVRKURLPathStatus);
    expect(statusComponents.query).to.beNil();
}

#pragma mark Requests

- (void)testPerformRequestWith200StatusCode {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performRequest:nil completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedData).notTo.beNil();
    expect(returnedError).to.beNil();
}

- (void)testPerformRequestWith401StatusCode {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:401];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performRequest:nil completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedData).to.beNil();
    expect(returnedError).notTo.beNil();
    expect(returnedError.code).to.equal(401);
}

- (void)testPerformRequestWithError {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:1001];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performRequest:nil completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedData).to.beNil();
    expect(returnedError).notTo.beNil();
    expect(returnedError.code).to.equal(1001);
}

- (void)testAuthorizationHeaderRequests {
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    
    VLCCommand *command   = [VLCCommand statusCommand];
    NSURLRequest *request = [httpClient urlRequestWithCommand:command];
    
    // Creates the session stub
    id urlSessionMock = [OCMockObject niceMockForClass:[NSURLSession class]];
    [[[urlSessionMock stub] andDo:^(NSInvocation *invocation) {
        //the block we will invoke
        void (^handler)(NSData *data, NSURLResponse *response, NSError *error) = nil;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be dataTaskWithRequest, 3 is completionHandler (block)
        [invocation getArgument:&handler atIndex:3];
        
        NSString *password   = [request valueForHTTPHeaderField:@"Authorization"];
        NSInteger statusCode = ([password isEqualToString:@"Basic OnBhc3N3b3Jk"]) ? 200 : 401;
        id urlResponse       = [NSHTTPURLResponseNiceMock mockWithStatusCode:statusCode];
        
        // Invoke the completion handler block
        handler([OCMockObject mockForClass:[NSData class]], urlResponse, nil);
    }] dataTaskWithRequest:request completionHandler:[OCMArg any]];
    
    httpClient.urlSession     = urlSessionMock;
    
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performRequest:request completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedData).notTo.beNil();
    expect(returnedError).to.beNil();
}

#pragma mark - Public

#pragma mark Methods

- (void)testConnection {
    id urlSessionMock = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];

    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    httpClient.delegate       = mockDelegate;

    __block VLCClientConnectionStatus returnedStatus = VLCClientConnectionStatusDisconnected;
    [httpClient setConnectionStatusChangeBlock:^(VLCClientConnectionStatus status) {
        returnedStatus = status;
    }];
    
    // Try connection
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient connectWithCompletionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnected];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    expect(returnedStatus).to.equal(VLCClientConnectionStatusConnected);
    expect(returnedData).toNot.beNil();
    expect(returnedError).to.beNil();
    
    // Try reconnection
    [httpClient connectWithCompletionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedStatus).to.equal(VLCClientConnectionStatusConnected);
    expect(returnedData).to.beNil();
    expect(returnedError).notTo.beNil();
    expect(returnedError.domain).to.equal(kVLCClientErrorDomain);
    expect(returnedError.code).to.equal(VLCClientErrorCodeConnectionAlreadyOpened);
}

- (void)testDisconnection {
    id urlSessionMock = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    httpClient.delegate       = mockDelegate;
    
    __block VLCClientConnectionStatus returnedStatus = VLCClientConnectionStatusDisconnected;
    [httpClient setConnectionStatusChangeBlock:^(VLCClientConnectionStatus status) {
        returnedStatus = status;
    }];
    
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient connectWithCompletionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnected];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    expect(returnedStatus).to.equal(VLCClientConnectionStatusConnected);
    expect(returnedData).toNot.beNil();
    expect(returnedError).to.beNil();
    
    [httpClient disconnectWithCompletionHandler:^(NSError *error) {
        returnedError = error;
    }];
    
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusDisconnected];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    expect(httpClient.connectionStatus).to.equal(VLCClientConnectionStatusDisconnected);
    expect(returnedStatus).to.equal(VLCClientConnectionStatusDisconnected);
    expect(returnedError).to.beNil();
}

#pragma mark Perform VLC Commands

- (void)testPerformCommandWithoutConnection {
    id urlSessionMock = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    
    VLCCommand *statusCommand      = [VLCCommand statusCommand];
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performCommand:statusCommand completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    // We can't perform a command if we are not connected
    expect(returnedData).to.beNil();
    expect(returnedError).toNot.beNil();
    expect(returnedError.domain).to.equal(kVLCClientErrorDomain);
    expect(returnedError.code).to.equal(VLCClientErrorCodeNotConnected);
}

- (void)testPerformDummyCommand {
    id urlSessionMock = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:dummyHost port:dummyPort username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;

    // So we make the connection
    [httpClient connectWithCompletionHandler:NULL];
    
    VLCCommand *statusCommand      = [VLCCommand statusCommand];
    __block NSData *returnedData   = nil;
    __block NSError *returnedError = nil;
    [httpClient performCommand:statusCommand completionHandler:^(NSData *data, NSError *error) {
        returnedData  = data;
        returnedError = error;
    }];
    
    [[[FBTestBlocker alloc] init] waitWithTimeout:0.1f];
    
    expect(returnedData).toNot.beNil();
    expect(returnedError).to.beNil();
}

@end
