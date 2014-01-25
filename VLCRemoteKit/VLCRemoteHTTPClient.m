//
//  VLCRemoteHTTPClient.m
//  VLCRemoteKit
//
//  Created by YannickL on 25/01/2014.
//  Copyright (c) 2014 Yannick Loriot. All rights reserved.
//

#import "VLCRemoteHTTPClient.h"

double const kVLCRemoteHTTPClientAPIVersion  = 3;
double const kVLCRemoteHTTPClientRefrechTime = 1.0f;

@interface VLCRemoteHTTPClient ()
/** The timer uses to keep the status up to date. */
@property (nonatomic, strong) NSTimer *timer;
/** The headers used to build the requests. */
@property (nonatomic, strong) NSDictionary *headers;
/**
 * The request to retrieve the current VLC status.
 * As the request will be performed each `kVLCRemoteHTTPClientRefrechTime`
 * we need to keep a reference to improve the performance.
 */
@property (nonatomic, strong) NSURLRequest *statusRequest;
/**
 * The request to retrieve the current playlist.
 */
@property (nonatomic, strong) NSURLRequest *playlistRequest;
/** The status URL components to help us to build the queries. */
@property (nonatomic, strong) NSURLComponents *statusURLComponents;
/** The session used to perform to retrieve the VLC status. */
@property (nonatomic, strong) NSURLSession *statusSession;
/** The session used to perform the command requests. */
@property (nonatomic, strong) NSURLSession *commandSession;

@end

@implementation VLCRemoteHTTPClient

- (void)dealloc {
    [_timer invalidate];
}

- (id)initWithURL:(NSURL *)url password:(NSString *)password {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:YES];
    
    return [self initWithURLComponents:urlComponents password:password];
}

- (id)initWithURLComponents:(NSURLComponents *)urlComponents password:(NSString *)password {
    // VLC doesn't need username for the credentials
    NSString *credentials   = [NSString stringWithFormat:@":%@", password];
    NSString *base64        = [[credentials dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authorization = [NSString stringWithFormat:@"Basic %@", base64];

    return [self initWithURLComponents:urlComponents headers:@{@"Authorization": authorization}];
}

- (id)initWithURLComponents:(NSURLComponents *)urlComponents headers:(NSDictionary *)headers {
    if ((self = [super init])) {
        _headers = headers;
        
        // Status
        urlComponents.path   = @"/requests/status.json";
        _statusRequest       = [self requestWithURLComponents:urlComponents];
        _statusURLComponents = [urlComponents copy];
        
        // Playlist
        urlComponents.path = @"/requests/playlist.json";
        _playlistRequest   = [self requestWithURLComponents:urlComponents];
        
        // Create the sessions
        NSURLSessionConfiguration *configuration    = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPMaximumConnectionsPerHost = 1;
        _statusSession                              = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionConfiguration *commandConfiguration    = [NSURLSessionConfiguration defaultSessionConfiguration];
        commandConfiguration.HTTPShouldUsePipelining       = YES;
        commandConfiguration.HTTPMaximumConnectionsPerHost = 3;
        _commandSession                                    = [NSURLSession sessionWithConfiguration:commandConfiguration];
    }
    return self;
}

#pragma mark - Private Methods

- (NSURLRequest *)requestWithURLComponents:(NSURLComponents *)urlComponents {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlComponents URL]];

    for (NSString *key in _headers) {
        [request setValue:[_headers objectForKey:key] forHTTPHeaderField:key];
    }

    return request;
}

- (void)remoteStatus {
    NSURLSessionDataTask *task = [_statusSession dataTaskWithRequest:_statusRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"Error: %@", error);
    }];
    [task resume];
}

#pragma mark - VLCRemoteClientProtocol Methods

- (void)connect {
    _timer = [NSTimer timerWithTimeInterval:kVLCRemoteHTTPClientRefrechTime target:self selector:@selector(remoteStatus) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)disconnect {
    [_timer invalidate];
}

- (void)status {
    
}

#pragma mark - VLCCommand Protocol Methods

- (void)play {
    
}

- (void)stop {
    
}

- (void)toogleFullscreen {
    _statusURLComponents.query = @"command=fullscreen";
    
    NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
    [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
}

@end
