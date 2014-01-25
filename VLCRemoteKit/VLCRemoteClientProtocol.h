//
//  VLCRemoteClientProtocol.h
//  VLCRemoteKitExample
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VLCRemoteClientProtocol <NSObject>

- (void)connect;
- (void)disconnect;
- (void)status;

@end
