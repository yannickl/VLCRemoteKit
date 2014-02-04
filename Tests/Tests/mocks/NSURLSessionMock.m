//
//  NSURLSessionMock.m
//  VLCRemoteKitTests
//
//  Created by YannickL on 04/02/2014.
//
//

#import "NSURLSessionMock.h"

@implementation NSURLSessionMock

+ (instancetype)niceMockWithStatusCode:(NSInteger)statusCode {
    // Creates the NSHTTPURLResponse stub and return the given status code
    id responseStub = [OCMockObject niceMockForClass:[NSHTTPURLResponse class]];
    [[[responseStub stub] andReturnValue:OCMOCK_VALUE((NSInteger)statusCode)] statusCode];
    
    // Creates the returned data
    NSData *data = [@"{\"fullscreen\":false,\"stats\":{\"inputbitrate\":0.450459,\"sentbytes\":0,\"lostabuffers\":0,\"averagedemuxbitrate\":0,\"readpackets\":476,\"demuxreadpackets\":0,\"lostpictures\":1,\"displayedpictures\":257,\"sentpackets\":0,\"demuxreadbytes\":4169958,\"demuxbitrate\":0.94235,\"playedabuffers\":431,\"demuxdiscontinuity\":0,\"decodedaudio\":431,\"sendbitrate\":0,\"readbytes\":5364480,\"averageinputbitrate\":0,\"demuxcorrupted\":0,\"decodedvideo\":273},\"aspectratio\":\"default\",\"audiodelay\":0,\"apiversion\":3,\"currentplid\":4,\"time\":8,\"volume\":272,\"length\":3024,\"random\":false,\"audiofilters\":{\"filter_0\":\"\"},\"rate\":1,\"videoeffects\":{\"hue\":0,\"saturation\":1,\"contrast\":1,\"brightness\":1,\"gamma\":1},\"state\":\"paused\",\"loop\":false,\"version\":\"2.1.2 Rincewind\",\"position\":0.0028960274,\"information\":{\"chapter\":0,\"chapters\":[],\"title\":0,\"category\":{\"meta\":{\"filename\":\"Hidden_iOS_7_Development_Gems-hd.mov\"},\"Flux 0\":{\"Canaux_\":\"St\u00C3\u00A9r\u00C3\u00A9o\",\"Langue_\":\"Anglais\",\"Fr\u00C3\u00A9quence_d\'\u00C3\u00A9chantillonnage\":\"48000 Hz\",\"Type_\":\"Audio\",\"Codec_\":\"MPEG AAC Audio (mp4a)\"},\"Flux 1\":{\"Codec_\":\"H264 - MPEG-4 AVC (part 10) (avc1)\",\"Langue_\":\"Anglais\",\"Format_d\u00C3\u00A9cod\u00C3\u00A9\":\"Planar 4:2:0 YUV\",\"D\u00C3\u00A9bit_d\'images_\":\"30\",\"Type_\":\"Vid\u00C3\u00A9o\",\"R\u00C3\u00A9solution_\":\"1920x1080\"}},\"titles\":[]},\"repeat\":false,\"subtitledelay\":0,\"equalizer\":[]}" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Creates the session stub
    id urlSessionMock = [OCMockObject niceMockForClass:[NSURLSession class]];
    [[[urlSessionMock stub] andDo:^(NSInvocation *invocation) {
        //the block we will invoke
        void (^completionHandler)(NSData *data, NSURLResponse *response, NSError *error) = nil;
        
        // 0 and 1 are reserved for invocation object
        // 2 would be dataTaskWithRequest, 3 is completionHandler (block)
        [invocation getArgument:&completionHandler atIndex:3];
        
        // Invoke the block
        completionHandler(data, responseStub, nil);
    }] dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]];
    
    return urlSessionMock;
}

@end
