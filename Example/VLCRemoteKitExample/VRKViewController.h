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
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <UIKit/UIKit.h>
#import "VLCClientProtocol.h"
#import "VLCRemoteProtocol.h"
#import "VLCRemotePlaylist.h"
#import "VRKConfigurationViewController.h"

@interface VRKViewController : UIViewController <UIPopoverControllerDelegate, VRKConfigurationDelegate, VLCClientDelegate, VLCRemoteDelegate>
@property (weak, nonatomic) IBOutlet UILabel         *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel         *filenameLabel;
@property (weak, nonatomic) IBOutlet UIButton        *connectButton;
@property (weak, nonatomic) IBOutlet UIButton        *stopButton;
@property (weak, nonatomic) IBOutlet UIButton        *toogePauseButton;
@property (weak, nonatomic) IBOutlet UIButton        *toggleFullscreenButton;
@property (weak, nonatomic) IBOutlet UILabel         *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel         *durationLabel;
@property (weak, nonatomic) IBOutlet UISlider        *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel         *volumeLabel;
@property (weak, nonatomic) IBOutlet UISlider        *volumeSlider;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButtonItem;

#pragma mark - Public Methods

- (IBAction)connectAction:(id)sender;
- (IBAction)playAction:(id)sender;
- (IBAction)stopAction:(id)sender;
- (IBAction)togglePauseAction:(id)sender;
- (IBAction)toggleFullScreenAction:(id)sender;
- (IBAction)seekAction:(id)sender;
- (IBAction)volumeAction:(id)sender;

@end
