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

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VLCCommandName) {
    VLCCommandNameStatus,
    VLCCommandNameStop,
    VLCCommandNameToogleFullscreen,
};

/**
 * A command is a convenient way to communicate with VLC via the client with an
 * unified API.
 */
@interface VLCCommand : NSObject

#pragma mark - Configuring the Command
/** @name Configuring the Command */

/**
 * @abstract The command's name.
 * @version 1.0.0
 */
@property (nonatomic, assign) VLCCommandName name;
/**
 * @abstract The command parameters.
 * @version 1.0.0
 */
@property (nonatomic, strong) NSDictionary   *params;

#pragma mark - Creating and Inializing Commands
/** @name Creating and Inializing Commands */

/**
 * @abstract Initializes a command using a name and some parameters.
 * @param name A command name.
 * @param params A dictionary of parameters to send with the command.
 * @version 1.0.0
 */
- (id)initWithName:(VLCCommandName)name params:(NSDictionary *)params;

/**
 * @abstract Creates and returns a command using a name and some parameters.
 * @param name A command name.
 * @param params A dictionary of parameters to send with the command.
 * @see initWithName:params:
 * @version 1.0.0
 */
+ (instancetype)commandWithName:(VLCCommandName)name params:(NSDictionary *)params;

#pragma mark - Convenience Constructors
/**@name Convenience Constructors */

/**
 * @abstract Creates and returns a command to retrieve the current VLC status.
 */
+ (instancetype)statusCommand;

@end
