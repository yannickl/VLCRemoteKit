//
//  VLCCommandProtocol.h
//  VLCRemoteKit
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VLCCommandProtocol <NSObject>

- (void)play;
- (void)stop;
- (void)toogleFullscreen;

@end
