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
#import "VLCCommand.h"

#import "NSError+VLC.h"

double const kVRKHTTPClientAPIVersion  = 3;

/** The recommended time interval to use to pull the status. */
NSTimeInterval const kVRKRefreshInterval           = 1.0f;
NSTimeInterval const kVRKTimeoutIntervalForRequest = 1.0f;

/** Absolute URL path to the status of VLC. */
NSString * const kVRKURLPathStatus   = @"/requests/status.json";
/** Absolute URL path to the playlist of VLC. */
NSString * const kVRKURLPathPlaylist = @"/requests/playlist.json";

@interface VLCHTTPClient ()
/** The headers used to build the requests. */
@property (nonatomic, strong) NSDictionary *headers;
/**
 * The request to retrieve the current player status of VLC.
 * @discussion As the request will be performed each kVRKRefreshInterval, we
 * need to keep a reference to improve the performance.
 */
@property (nonatomic, strong) NSURLRequest *playerStatusURLRequest;
/** The URL request to retrieve the playlist data. */
@property (nonatomic, strong) NSURLRequest *playlistURLRequest;
/** The player status URL components to help us to build the queries. */
@property (nonatomic, strong) NSURLComponents *playerStatusURLComponents;
/** The session used to perform the requests. */
@property (nonatomic, strong) NSURLSession *urlSession;
/** The connection status. */
@property (assign) VLCClientConnectionStatus connectionStatus;

/** Creates a resquest  */
+ (NSURLRequest *)requestWithURLComponents:(NSURLComponents *)urlComponents;

- (void)performRequest:(NSURLRequest *)request completionHandler:(void (^) (NSData *data, NSError *error))completionHandler;

@end

@implementation VLCHTTPClient

- (void)dealloc {
    [_urlSession invalidateAndCancel];
    
    [self removeObserver:self forKeyPath:@"connectionStatus"];
}

- (id)initWithHostname:(NSString *)hostname port:(NSInteger)port username:(NSString *)username password:(NSString *)password {
    NSURLComponents *baseURLComponent = [[NSURLComponents alloc] init];
    baseURLComponent.scheme           = @"http";
    baseURLComponent.host             = hostname;
    baseURLComponent.port             = [NSNumber numberWithInteger:port];
    baseURLComponent.user             = username ?: @"";
    baseURLComponent.password         = password ?: @"";
    
    return [self initWithURLComponents:baseURLComponent];
}

+ (instancetype)clientWithHostname:(NSString *)hostname port:(NSInteger)port username:(NSString *)username password:(NSString *)password {
    return [[self alloc] initWithHostname:hostname port:port username:username password:password];
}

- (id)initWithURLComponents:(NSURLComponents *)urlComponents {
    NSURLSessionConfiguration *configuration    = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.HTTPShouldUsePipelining       = YES;
    configuration.HTTPMaximumConnectionsPerHost = 3;
    configuration.timeoutIntervalForRequest     = kVRKTimeoutIntervalForRequest;
    configuration.timeoutIntervalForResource    = kVRKTimeoutIntervalForRequest;
    NSURLSession *urlSession                    = [NSURLSession sessionWithConfiguration:configuration];
    
    return [self initWithURLComponents:urlComponents urlSession:urlSession];
}

- (id)initWithURLComponents:(NSURLComponents *)urlComponents urlSession:(NSURLSession *)urlSession  {
    if ((self = [super init])) {
        // Build the player status component
        NSURLComponents *playerStatusURLComponents = [urlComponents copy];
        playerStatusURLComponents.path             = kVRKURLPathStatus;
        _playerStatusURLComponents                 = playerStatusURLComponents;
        _playerStatusURLRequest                    = [[self class] requestWithURLComponents:playerStatusURLComponents];
        
        // Build the playlist component
        NSURLComponents *playlistURLComponents = [urlComponents copy];
        playlistURLComponents.path             = kVRKURLPathPlaylist;
        _playlistURLRequest                    = [[self class] requestWithURLComponents:playlistURLComponents];
        
        _connectionStatus = VLCClientConnectionStatusDisconnected;
        _urlSession       = urlSession;
        
        [self addObserver:self forKeyPath:@"connectionStatus" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - Private Methods

+ (NSURLRequest *)requestWithURLComponents:(NSURLComponents *)urlComponents {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlComponents URL]];
    request.timeoutInterval      = kVRKTimeoutIntervalForRequest;
    
    return request;
}

- (NSString *)queryStringFromCommand:(VLCCommand *)command {
    NSMutableString *queryString = nil;
    
    switch (command.name) {
        case VLCCommandNameStatus:
            return nil;
            
        default:
            return nil;
    }
    
    for (NSString *key in command.params) {
        [queryString appendString:[NSString stringWithFormat:@"&%@", command.params[key]]];
    }
    
    return queryString;
}

- (NSURLRequest *)urlRequestWithCommand:(VLCCommand *)command {
    NSURLComponents *urlComponents = [_playerStatusURLComponents copy];
    urlComponents.query            = [self queryStringFromCommand:command];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[urlComponents URL]];
    request.timeoutInterval      = kVRKTimeoutIntervalForRequest;
    return request;
}

- (void)performCommand:(NSString *)command withParameters:(NSString *)parameters {
    if (_connectionStatus == VLCClientConnectionStatusConnected) {
        NSMutableString *query = [NSMutableString stringWithFormat:@"command=%@", command];
        if (parameters) {
            [query appendString:[NSString stringWithFormat:@"&%@", parameters]];
        }
        _playerStatusURLComponents.query = query;
        
        NSURLRequest *request = [[self class] requestWithURLComponents:_playerStatusURLComponents];
        [[_urlSession dataTaskWithRequest:request completionHandler:NULL] resume];
    }
}

- (void)listeningWithCompletionHandler:(void (^)(NSData *data, NSError *))completionHandler {
    if (_connectionStatus != VLCClientConnectionStatusDisconnected) {
        __weak typeof(self) weakSelf = self;
        [self performRequest:_playerStatusURLRequest completionHandler:^(NSData *data, NSError *error) {
            __strong typeof(self) strongSelf = weakSelf;
            
            if (_connectionStatus != VLCClientConnectionStatusDisconnected) {
                
                // Update the current connection status
                VLCClientConnectionStatus currentStatus = (!error) ? VLCClientConnectionStatusConnected : (error.code == 401) ? VLCClientConnectionStatusUnauthorized : VLCClientConnectionStatusUnreachable;
                if (_connectionStatus != currentStatus) {
                    strongSelf.connectionStatus = currentStatus;
                }
                
                // If all its ok, update the player
                if (!error) {
                    
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kVRKRefreshInterval * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self listeningWithCompletionHandler:nil];
                });
            }
        }];
    }
}

- (void)performRequest:(NSURLRequest *)request completionHandler:(void (^) (NSData *data, NSError *error))completionHandler {
    [[_urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (completionHandler) {
            if (error) {
                return completionHandler(nil, error);
            }
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode            = httpResponse.statusCode;
            
            if (statusCode != 200) {
                NSDictionary *userInfo = nil;
                if (statusCode == 401) {
                    userInfo = @{
                                 NSLocalizedDescriptionKey: NSLocalizedString(@"Request failed", nil),
                                 NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Unauthorized", nil),
                                 NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the client or VLC credentials", nil)
                                 };
                }
                
                NSError *error = [NSError errorWithDomain:kVLCClientErrorDomain code:statusCode userInfo:userInfo];
                completionHandler(nil, error);
            }
            
            completionHandler(data, nil);
        }
    }] resume];
}

#pragma mark - VLCRemoteClientProtocol Methods

- (void)connectWithCompletionHandler:(void (^)(NSData *data, NSError *))completionHandler {
    @synchronized (self) {
        if (_connectionStatus == VLCClientConnectionStatusDisconnected) {
            self.connectionStatus = VLCClientConnectionStatusConnecting;
            
            [self listeningWithCompletionHandler:completionHandler];
        }
        else if (completionHandler) {
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Connection failed.", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The client is already connected.", nil)
                                       };
            NSError *error = [NSError errorWithDomain:kVLCClientErrorDomain code:VLCClientErrorCodeAlreadyConnected userInfo:userInfo];
            completionHandler(nil, error);
        }
    }
}

- (void)disconnectWithCompletionHandler:(void (^) (NSError *error))completionHandler {
    @synchronized (self ) {
        _connectionStatus = VLCClientConnectionStatusDisconnected;
        
        completionHandler(nil);
    }
}

- (void)performCommand:(VLCCommand *)command completionHandler:(void (^) (NSData *data, NSError *error))completionHandler {
    NSURLRequest *commandURLRequest = [self urlRequestWithCommand:command];
    
    [self performRequest:commandURLRequest completionHandler:completionHandler];
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

#pragma mark - Key-Value Observing Delegate Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"connectionStatus"] && ![[change objectForKey:@"new"] isEqual:[change objectForKey:@"old"]]) {
        if (_delegate && [_delegate respondsToSelector:@selector(client:reachabilityStatusDidChange:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate client:self reachabilityStatusDidChange:_connectionStatus];
            });
        }
    }
}

@end
