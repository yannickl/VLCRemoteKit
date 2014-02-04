//
//  iOSTests.m
//  iOSTests
//
//  Created by YannickL on 26/01/2014.
//
//

#import <XCTest/XCTest.h>
#import <VLCRemoteKit/VLCRemoteKit.h>

#define EXP_SHORTHAND
#import "Expecta.h"
#import "OCMock.h"
#import "FBTestBlocker.h"

@interface VLCHTTPClient (UnitTestAdditions)
@property (nonatomic, strong) NSURLSession   *urlSession;
@property (assign) VLCClientConnectionStatus connectionStatus;

@end

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

- (void)testConnectionWith200StatusCode {
    id responseStub = [OCMockObject niceMockForClass:[NSHTTPURLResponse class]];
    [[[responseStub stub] andReturnValue:OCMOCK_VALUE((NSInteger)200)] statusCode];
    
    id urlSessionMock = [OCMockObject niceMockForClass:[NSURLSession class]];
    [[[urlSessionMock stub] andDo:^(NSInvocation *invocation) {
        //the block we will invoke
        void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = nil;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be dataTaskWithRequest, 3 is completionHandler (block)
        [invocation getArgument:&completionHandler atIndex:3];
        
        // Invoke the block
        completionHandler(_statusStub, responseStub, nil);
    }] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
    
    id mockDelegate = [OCMockObject niceMockForProtocol:@protocol(VLCClientDelegate)];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 username:nil password:@"password"];
    httpClient.urlSession     = urlSessionMock;
    httpClient.delegate       = mockDelegate;
    [httpClient connectWithCompletionHandler:nil];
    
    [[mockDelegate expect] client:httpClient connectionStatusDidChanged:VLCClientConnectionStatusConnected];
    [FBTestBlocker waitForVerifiedMock:mockDelegate delay:2.0f];
}

@end
