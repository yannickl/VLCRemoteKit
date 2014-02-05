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

#import "NSURLSessionNiceMock.h"
#import "NSHTTPURLResponseNiceMock.h"

#import "VLCHTTPClient_UnitTestAdditions.h"

#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "FBTestBlocker.h"

@interface VLCHTTPClientTests : XCTestCase
@end

@implementation VLCHTTPClientTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Private

#pragma mark Properties

- (void)testConnectionStatusUpdateViaDelegates {
    // Create the delegate
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    // Create the client
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
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
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
    
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

- (void)testPerformRequestWith200StatusCode {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
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
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
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
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
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

#pragma mark - Public

#pragma mark Methods

- (void)testConnection {
    id urlSessionMock = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];

    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
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
}

@end
