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
@property (nonatomic, strong) VLCHTTPClient *vlcClient;

@end

@implementation VRKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    _vlcClient          = [VLCHTTPClient clientWithHostname:@"192.168.0.12" port:8080 username:nil password:@"password"];
    _vlcClient.delegate = self;
    [_vlcClient setConnectionStatusChangeBlock:^(VLCClientConnectionStatus status) {
        NSLog(@"setConnectionStatusChangeBlock CU: %@", [NSThread currentThread]);
        NSLog(@"setConnectionStatusChangeBlock MA: %@", [NSThread mainThread]);
    }];
    [_vlcClient connectWithCompletionHandler:^(NSData *data, NSError *error) {
        NSLog(@"connectWithCompletionHandler CU: %@", [NSThread currentThread]);
        NSLog(@"connectWithCompletionHandler MA: %@", [NSThread mainThread]);
    }];
}

#pragma mark - Public Methods


- (IBAction)startListeningAction:(id)sender {
    [_vlcClient disconnectWithCompletionHandler:^(NSError *error) {
        _vlcClient          = [VLCHTTPClient clientWithHostname:@"192.168.0.12" port:8080 username:nil password:@"password"];
        _vlcClient.delegate = self;
        [_vlcClient connectWithCompletionHandler:NULL];
    }];
}

- (IBAction)playAction:(id)sender {
    [_vlcClient.player playItemWithId:5];
}

- (IBAction)stopAction:(id)sender {
    [_vlcClient.player stop];
}

- (IBAction)tooglePauseAction:(id)sender {
    _vlcClient.player.paused = !_vlcClient.player.paused;
}

- (IBAction)toogleFullScreenAction:(id)sender {
    _vlcClient.player.fullscreenMode = !_vlcClient.player.fullscreenMode;
}

#pragma mark - VLCRemoteClient Delegate Methods

- (void)client:(id)client connectionStatusDidChanged:(VLCClientConnectionStatus)status {
    NSLog(@"reachabilityStatusDidChange CU: %@", [NSThread currentThread]);
    NSLog(@"reachabilityStatusDidChange MA: %@", [NSThread mainThread]);
}

@end
