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

@interface VLCRemotePlaylistTests : XCTestCase
@property (nonatomic, strong) id                clientMock;
@property (nonatomic, strong) VLCRemotePlaylist *remotePlaylist;

@end

@implementation VLCRemotePlaylistTests

- (void)setUp {
    [super setUp];

    id clientMock   = [OCMockObject niceMockForProtocol:@protocol(VLCClientProtocol)];
    _remotePlaylist = [VLCRemotePlaylist remoteWithVLCClient:clientMock];
}

- (void)tearDown {
    self.remotePlaylist = nil;
    
    [super tearDown];
}

#pragma mark - Tests

#pragma mark Accessing Player Properties

- (void)testGetItems {
    _remotePlaylist.state = @{ };
    expect(_remotePlaylist.items).to.haveCountOf(0);
    
    _remotePlaylist.state = @{
                              @"ro":@"rw",
                              @"type":@"node",
                              @"name":@"Undefined",
                              @"id":@"1",
                              @"children":@[]
                              };
    expect(_remotePlaylist.items).to.haveCountOf(0);
    
    _remotePlaylist.state = @{
                            @"ro":@"rw",
                            @"type":@"node",
                            @"name":@"Undefined",
                            @"id":@"1",
                            @"children":@[@{
                                @"ro":@"ro",
                                @"type":@"node",
                                @"name":@"Playlist",
                                @"id":@"2",
                                @"children":@[@{
                                    @"ro":@"rw",
                                    @"type":@"leaf",
                                    @"name":@"Matrix Reloaded",
                                    @"id":@"4"
                                },@{
                                    @"ro":@"rw",
                                    @"type":@"leaf",
                                    @"name":@"Matrix Reloaded",
                                    @"id":@"5",
                                    @"current":@"current"
                                    },@{
                                    @"ro":@"rw",
                                    @"type":@"leaf",
                                    @"name":@"Matrix Revolution",
                                    @"id":@"5"
                                                  }]
                            },@{
                                @"ro":@"ro",
                                @"type":@"node",
                                @"name":@"Media Library",
                                @"id":@"3",
                                @"children":@[]
                            }]
                            };
    expect(_remotePlaylist.items).to.haveCountOf(3);
}

- (void)testItemCreation {
    VLCPlaylistItem *item = [VLCPlaylistItem itemWithJSON:@{
                                   @"ro":@"rw",
                                   @"type":@"leaf",
                                   @"name":@"Matrix Reloaded",
                                   @"id":@"4"
                                   }];
    
    expect(item.name).to.equal(@"Matrix Reloaded");
    expect(item.identifier).to.equal(4);
}

@end
