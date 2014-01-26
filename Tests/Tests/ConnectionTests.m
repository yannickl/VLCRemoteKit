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

@interface VLCHTTPClient (UnitTestAdditions)
@property (nonatomic, strong) NSURLRequest *statusRequest;
@property (nonatomic, strong) NSURLSession *statusSession;
@property (nonatomic, strong) NSURLSession *commandSession;

@end
@interface iOSTests : XCTestCase

@end

@implementation iOSTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHTTPClient
{
    id statusSessionMock = [OCMockObject niceMockForClass:[NSURLSession class]];
    [[statusSessionMock expect] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
    
    VLCHTTPClient *httpClient = [VLCHTTPClient clientWithHostname:@"1.2.3.4" port:8080 password:@"password"];
    httpClient.statusSession  = statusSessionMock;
    [httpClient connect];
    
    [statusSessionMock verify];
}

@end
