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

#import "VLCRemoteObject.h"
#import "VLCRemoteObject_Private.h"
#import "VLCCommand.h"

@implementation VLCRemoteObject

#pragma mark - Creating and Initializing a Remote Client

- (id)initWithVLCClient:(id<VLCClientProtocol>)client {
    if ((self = [super init])) {
        NSParameterAssert(client);
        
        self.state = 0;
        _client    = client;
    }
    return self;
}

+ (instancetype)remoteWithVLCClient:(id<VLCClientProtocol>)client {
    return [[self alloc] initWithVLCClient:client];
}

#pragma mark - Private Methods

- (void)updateStateWithData:(NSData *)data {
    NSUInteger dataHash = [data hash];

    if (self.stateHash != dataHash) {
        NSError *error      = nil;
        NSDictionary *state = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (!error) {
            [self updateWithState:state andHash:dataHash];
        }
    }
}

- (void)updateWithState:(NSDictionary *)state andHash:(NSUInteger)stateHash {
    if (self.stateHash != stateHash && state != nil) {
        self.stateHash = stateHash;
        self.state     = state;
        
        if (_delegate) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate remoteObjectDidChanged:self];
            });
        }
    }
}

@end
