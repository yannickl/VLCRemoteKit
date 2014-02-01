//
//  NSError+VLC.h
//  VLCRemoteKitExample
//
//  Created by YannickL on 01/02/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * The VLC client error domain.
 */
extern NSString * const kVLCClientErrorDomain;

/**
 * The VLC client error codes. Codes below 1000 are reserved for HTML status
 * codes (e.g. 404, 500, etc.).
 */
typedef NS_ENUM(NSInteger, VLCClientErrorCode) {
    /** The client is already connected. */
    VLCClientErrorCodeAlreadyConnected = 1000,
};

@interface NSError (VLC)

@end
