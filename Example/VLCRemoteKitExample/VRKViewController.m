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
@property (nonatomic, strong) VLCHTTPClient *remoteVLC;

@end

@implementation VRKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _remoteVLC          = [VLCHTTPClient clientWithHostname:@"192.168.0.12" port:8080 username:nil password:@"password"];
    _remoteVLC.delegate = self;
    [_remoteVLC connectWithCompletionHandler:^(NSData *data, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - Public Methods


- (IBAction)startListeningAction:(id)sender {
    [_remoteVLC disconnectWithCompletionHandler:^(NSError *error) {
        _remoteVLC          = [VLCHTTPClient clientWithHostname:@"192.168.0.12" port:8080 username:nil password:@"password"];
        _remoteVLC.delegate = self;
        [_remoteVLC connectWithCompletionHandler:NULL];
    }];
}

- (IBAction)playAction:(id)sender {
    [_remoteVLC playItemWithId:5];
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

#pragma mark - VLCRemoteClient Delegate Methods

- (void)client:(id)client reachabilityStatusDidChange:(VLCClientConnectionStatus)status {
    NSLog(@"CU: %@", [NSThread currentThread]);
    NSLog(@"MA: %@", [NSThread mainThread]);
}

- (void)client:(id)client playerStatusDidChange:(VLCRemotePlayer *)status {
    
}

@end
