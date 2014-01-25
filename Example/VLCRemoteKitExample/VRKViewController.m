//
//  VRKViewController.m
//  VLCRemoteKitExample
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "VRKViewController.h"
#import "VLCRemoteKit.h"

@interface VRKViewController ()
@property (nonatomic, strong) VLCHTTPRemoteClient *remoteVLC;
@end

@implementation VRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"VLC Remote Kit Example";
    
    _remoteVLC = [[VLCHTTPRemoteClient alloc] initWithURL:[NSURL URLWithString:@"http://192.168.0.12:8080"] password:@"password"];
}

#pragma mark - Public Methods


- (IBAction)startListeningAction:(id)sender {
}

- (IBAction)playAction:(id)sender {
    [_remoteVLC playItemWithId:-1];
}

- (IBAction)stopAction:(id)sender {
    [_remoteVLC stop];
}

- (IBAction)tooglePauseAction:(id)sender {
    [_remoteVLC tooglePause];
}

- (IBAction)toogleFullScreenAction:(id)sender {
    [_remoteVLC toogleFullscreen];
}

@end
