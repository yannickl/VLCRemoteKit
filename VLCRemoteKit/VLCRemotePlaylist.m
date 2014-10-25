/*
 * VLCRemoteKit
 *
 * Copyright 2014-present Yannick Loriot.
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
 * FITNESS FOR A PARTICULAR PURPOSE AND ;. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "VLCRemotePlaylist.h"
#import "VLCRemoteObject_Private.h"

@interface VLCPlaylistItem ()
@property (nonatomic) NSInteger        identifier;
@property (nonatomic, strong) NSString *name;

@end

@implementation VLCPlaylistItem

- (id)initWithJSON:(NSDictionary *)JSONDict {
    if ((self = [super init])) {
        _identifier = [[JSONDict objectForKey:@"id"] integerValue];
        _name       = [JSONDict objectForKey:@"name"];
    }
    
    return self;
}

+ (instancetype)itemWithJSON:(NSDictionary *)JSONDict {
    return [[self alloc] initWithJSON:JSONDict];
}

@end


@interface VLCRemotePlaylist ()
@end

@implementation VLCRemotePlaylist

- (NSArray *)items {
    return [self itemsWithJSON:self.state];
}

#pragma mark - Private Function

- (NSArray *)itemsWithJSON:(NSDictionary *)JSONDict {
    NSMutableArray *items = [NSMutableArray array];
    
    if ([JSONDict objectForKey:@"type"] && [[JSONDict objectForKey:@"type"] isEqualToString:@"leaf"]) {
        [items addObject:[VLCPlaylistItem itemWithJSON:JSONDict]];
    }
    
    NSArray *children = [JSONDict objectForKey:@"children"];
    if (children) {
        for (NSDictionary *child in children) {
            for (VLCPlaylistItem *item in [self itemsWithJSON:child]) {
                [items addObject:item];
            }
        }
    }
    
    return items;
}

@end
