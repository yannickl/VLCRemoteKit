//
//  VRKViewController.h
//  VLCRemoteKitExample
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VLCClientProtocol.h"

@interface VRKViewController : UIViewController <VLCClientDelegate>

#pragma mark - Public Methods

- (IBAction)startListeningAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)stopAction:(id)sender;
- (IBAction)tooglePauseAction:(id)sender;
- (IBAction)toogleFullScreenAction:(id)sender;

@end
