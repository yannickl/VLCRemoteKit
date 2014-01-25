/*
 * YLMoment.h
 *
 * Copyright 2014 Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "VLCHTTPRemoteClient.h"

double const kVRKHTTPClientAPIVersion        = 3;
NSTimeInterval const kVRKDefaultTimeInterval = 1.0f;

@interface VLCHTTPRemoteClient ()
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
/** The internal status. */
@property (atomic, strong) NSDictionary *status;

@end

@implementation VLCHTTPRemoteClient

- (void)dealloc {
    [_timer invalidate];
}

- (id)initWithHostname:(NSString *)hostname port:(NSInteger)port password:(NSString *)password {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme           = @"http";
    components.host             = hostname;
    components.port             = [NSNumber numberWithInteger:port];
    
    return [self initWithURLComponents:components password:password];
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

- (void)retrieveRemoteStatus {
    NSURLSessionDataTask *task = [_statusSession dataTaskWithRequest:_statusRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"Error: %@", error);
    }];
    [task resume];
}

#pragma mark - VLCRemoteClientProtocol Methods

- (BOOL)isVersionSupported {
    NSURLSessionDataTask *task = [_statusSession dataTaskWithRequest:_statusRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"Error: %@", error);
    }];
    [task resume];
    return NO;
}

- (void)startListeningForStatusUpdateWithTimeInterval:(NSTimeInterval)timeInterval {
    _timer = [NSTimer timerWithTimeInterval:timeInterval
                                     target:self
                                   selector:@selector(retrieveRemoteStatus)
                                   userInfo:nil
                                    repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)stopListeningForStatusUpdate {
    [_timer invalidate];
}

- (void)getStatusWithCompletionHandler:(VLCRemoteClientCallback)completionHandler {

}

#pragma mark - VLCCommand Protocol Methods

- (void)playItemWithId:(NSInteger)itemIdentifier {
    _statusURLComponents.query = @"command=pl_play";
    
    NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
    [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
}

- (void)tooglePause {
    _statusURLComponents.query = @"command=pl_pause";
    
    NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
    [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
}

- (void)stop {
    _statusURLComponents.query = @"command=pl_stop";
    
    NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
    [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
}

- (void)toogleFullscreen {
    _statusURLComponents.query = @"command=fullscreen";
    
    NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
    [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
}

@end
