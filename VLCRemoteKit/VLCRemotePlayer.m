/*
 * YLMoment.h
 *
 * Copyright 2014 Yannick Loriot.
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

#import "VLCRemotePlayer.h"
#import "VLCCommand.h"

@interface VLCRemotePlayer ()
@property (nonatomic, weak) id<VLCClientProtocol> client;

@end

@implementation VLCRemotePlayer

#pragma mark - Creating and Initializing a Remote Client

- (id)initWithClient:(id<VLCClientProtocol>)client {
    if ((self = [super init])) {
        _client = client;
    }
    return self;
}

+ (instancetype)remotePlayerWithClient:(id<VLCClientProtocol>)client {
    return [[self alloc] initWithClient:client];
}

#pragma mark - VLCCommand Protocol Methods

- (void)playItemWithId:(NSInteger)itemIdentifier {
    if (_client) {
        
    }
}

- (void)tooglePause {
    if (_client) {
        VLCCommand *tooglePauseCommand = [VLCCommand tooglePauseCommand];
        [_client performCommand:tooglePauseCommand completionHandler:nil];
    }
}

- (void)stop {
    if (_client) {
        
    }
}

- (void)toogleFullscreen {
    if (_client) {
        VLCCommand *toogleFullscreenCommand = [VLCCommand toogleFullscreenCommand];
        [_client performCommand:toogleFullscreenCommand completionHandler:nil];
    }
}

@end
