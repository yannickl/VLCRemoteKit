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
@property (nonatomic, strong) NSData *statusStub;

@end

@implementation VLCHTTPClientTests

- (void)setUp {
    [super setUp];
    self.statusStub = [@"{\"fullscreen\":false,\"stats\":{\"inputbitrate\":0.450459,\"sentbytes\":0,\"lostabuffers\":0,\"averagedemuxbitrate\":0,\"readpackets\":476,\"demuxreadpackets\":0,\"lostpictures\":1,\"displayedpictures\":257,\"sentpackets\":0,\"demuxreadbytes\":4169958,\"demuxbitrate\":0.94235,\"playedabuffers\":431,\"demuxdiscontinuity\":0,\"decodedaudio\":431,\"sendbitrate\":0,\"readbytes\":5364480,\"averageinputbitrate\":0,\"demuxcorrupted\":0,\"decodedvideo\":273},\"aspectratio\":\"default\",\"audiodelay\":0,\"apiversion\":3,\"currentplid\":4,\"time\":8,\"volume\":272,\"length\":3024,\"random\":false,\"audiofilters\":{\"filter_0\":\"\"},\"rate\":1,\"videoeffects\":{\"hue\":0,\"saturation\":1,\"contrast\":1,\"brightness\":1,\"gamma\":1},\"state\":\"paused\",\"loop\":false,\"version\":\"2.1.2 Rincewind\",\"position\":0.0028960274,\"information\":{\"chapter\":0,\"chapters\":[],\"title\":0,\"category\":{\"meta\":{\"filename\":\"Hidden_iOS_7_Development_Gems-hd.mov\"},\"Flux 0\":{\"Canaux_\":\"St\u00C3\u00A9r\u00C3\u00A9o\",\"Langue_\":\"Anglais\",\"Fr\u00C3\u00A9quence_d\'\u00C3\u00A9chantillonnage\":\"48000 Hz\",\"Type_\":\"Audio\",\"Codec_\":\"MPEG AAC Audio (mp4a)\"},\"Flux 1\":{\"Codec_\":\"H264 - MPEG-4 AVC (part 10) (avc1)\",\"Langue_\":\"Anglais\",\"Format_d\u00C3\u00A9cod\u00C3\u00A9\":\"Planar 4:2:0 YUV\",\"D\u00C3\u00A9bit_d\'images_\":\"30\",\"Type_\":\"Vid\u00C3\u00A9o\",\"R\u00C3\u00A9solution_\":\"1920x1080\"}},\"titles\":[]},\"repeat\":false,\"subtitledelay\":0,\"equalizer\":[]}" dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown {
    self.statusStub = nil;
    
    [super tearDown];
}

#pragma mark - Private

#pragma mark Properties

- (void)testConnectionStatusChangeDelegate {
    // Create the delegate
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    // Create the client
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
    httpClient.delegate       = mockDelegate;
    
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

#pragma mark - Public

#pragma mark Methods

- (void)testConnectionWith200StatusCode {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:200];

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

- (void)testConnectionWith401StatusCode {
    id urlSessionMock   = [NSURLSessionNiceMock mockWithReturnedStatusCode:401];
    
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
    
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusUnauthorized];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:0.1f];
    
    expect(returnedStatus).to.equal(VLCClientConnectionStatusUnauthorized);
    expect(returnedData).to.beNil();
    expect(returnedError).notTo.beNil();
}

@end
