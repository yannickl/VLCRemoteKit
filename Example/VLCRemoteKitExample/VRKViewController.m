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

@end

@implementation VRKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.title = @"VLC Remote Kit Example";
}

#pragma mark - Public Methods


- (IBAction)connectAction:(id)sender {
}

- (IBAction)toogleFullScreenAction:(id)sender {
    VLCRemoteHTTPClient *client = [[VLCRemoteHTTPClient alloc] initWithURL:[NSURL URLWithString:@"http://192.168.0.12:8080"] password:@"password"];
    //[client connect];
    [client toogleFullscreen];
}

@end
