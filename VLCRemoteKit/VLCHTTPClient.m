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

#import "VLCHTTPClient.h"

double const kVRKHTTPClientAPIVersion              = 3;

NSTimeInterval const kVRKDefaultRefreshInterval    = 1.0f;
NSTimeInterval const kVRKTimeoutIntervalForRequest = 1.0f;

@interface VLCHTTPClient ()
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
/** Flag to know whether the client needs listening to remote status. */
@property (atomic, getter = isListenning) BOOL listening;
/** The connection status. */
@property (nonatomic, assign) VLCClientStatus status;

@end

@implementation VLCHTTPClient

- (void)dealloc {
    [_statusSession invalidateAndCancel];
    [_commandSession invalidateAndCancel];
    NSLog(@"dealloc");
}

- (id)initWithHostname:(NSString *)hostname port:(NSInteger)port password:(NSString *)password {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme           = @"http";
    components.host             = hostname;
    components.port             = [NSNumber numberWithInteger:port];
    
    return [self initWithURLComponents:components password:password];
}

+ (instancetype)clientWithHostname:(NSString *)hostname port:(NSInteger)port password:(NSString *)password {
    return [[self alloc] initWithHostname:hostname port:port password:password];
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

    return [self initWithURLComponents:urlComponents headers:@{ @"Authorization": authorization }];
}

- (id)initWithURLComponents:(NSURLComponents *)urlComponents headers:(NSDictionary *)headers {
    if ((self = [super init])) {
        _headers = headers;
        
        _status = VLCClientStatusNone;
        
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
        configuration.timeoutIntervalForRequest     = kVRKTimeoutIntervalForRequest;
        configuration.timeoutIntervalForResource    = kVRKTimeoutIntervalForRequest;
        _statusSession                              = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionConfiguration *commandConfiguration    = [NSURLSessionConfiguration defaultSessionConfiguration];
        commandConfiguration.HTTPShouldUsePipelining       = YES;
        commandConfiguration.HTTPMaximumConnectionsPerHost = 3;
        configuration.timeoutIntervalForRequest            = kVRKTimeoutIntervalForRequest;
        configuration.timeoutIntervalForResource           = kVRKTimeoutIntervalForRequest;
        _commandSession                                    = [NSURLSession sessionWithConfiguration:commandConfiguration];
    }
    return self;
}

#pragma mark - Private Methods

- (NSURLRequest *)requestWithURLComponents:(NSURLComponents *)urlComponents {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlComponents URL]];
    request.timeoutInterval      = kVRKTimeoutIntervalForRequest;
    
    for (NSString *key in _headers) {
        [request setValue:[_headers objectForKey:key] forHTTPHeaderField:key];
    }

    return request;
}

- (void)performCommand:(NSString *)command withParameters:(NSString *)parameters {
    if (_status == VLCClientStatusConnected) {
        NSMutableString *query = [NSMutableString stringWithFormat:@"command=%@", command];
        if (parameters) {
            [query appendString:[NSString stringWithFormat:@"&%@", parameters]];
        }
        _statusURLComponents.query = query;
        
        NSURLRequest *request = [self requestWithURLComponents:_statusURLComponents];
        [[_commandSession dataTaskWithRequest:request completionHandler:NULL] resume];
    }
}

- (void)listening {
    if (_listening) {
        [[_statusSession dataTaskWithRequest:_statusRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (_listening) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                NSInteger statusCode            = httpResponse.statusCode;
                
                // Notified the delegate if the reachability status change
                VLCClientStatus currentStatus = (statusCode == 200) ? VLCClientStatusConnected : (statusCode == 401) ? VLCClientStatusUnauthorized : VLCClientStatusNone;
                if (_status != currentStatus) {
                    _status = currentStatus;
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(client:reachabilityDidChange:)]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_delegate client:self reachabilityDidChange:_status];
                        });
                    }
                }
                
                // If all its ok, update the player
                if (statusCode == 200) {

                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kVRKDefaultRefreshInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self listening];
                });
            }
        }] resume];
    }
}

#pragma mark - VLCRemoteClientProtocol Methods

- (void)connect {
    @synchronized (self) {
        if (!_listening) {
            _listening = YES;
            
            [self listening];
        }
    }
}

- (void)disconnect {
    @synchronized (self) {
        _listening = NO;
    }
}

#pragma mark - VLCCommand Protocol Methods

- (void)playItemWithId:(NSInteger)itemIdentifier {
    NSString *parameters = nil;
    if (itemIdentifier >= 0) {
        parameters = [NSString stringWithFormat:@"id=%ld", (long)itemIdentifier];
    }
    [self performCommand:@"pl_play" withParameters:parameters];
}

- (void)tooglePause {
    [self performCommand:@"pl_pause" withParameters:nil];
}

- (void)stop {
    [self performCommand:@"pl_stop" withParameters:nil];
}

- (void)toogleFullscreen {
    [self performCommand:@"fullscreen" withParameters:nil];
}

@end
