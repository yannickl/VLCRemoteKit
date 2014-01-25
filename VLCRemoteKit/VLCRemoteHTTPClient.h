//
//  VLCRemoteHTTPClient.h
//  VLCRemoteKit
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "VLCCommandProtocol.h"
#import "VLCRemoteClientProtocol.h"

/** The API version supported by the client. */
extern double const kVLCRemoteHTTPClientAPIVersion;

@interface VLCRemoteHTTPClient : NSObject <VLCCommandProtocol, VLCRemoteClientProtocol>

- (id)initWithURL:(NSURL *)url password:(NSString *)password;

@end
