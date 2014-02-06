/*
 * VLCRemoteKit
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

#import "VRKConfigurationViewController.h"

@interface VRKConfigurationViewController ()

@end

@implementation VRKConfigurationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *ip                 = [userDefaults stringForKey:@"ip"];
    NSString *password           = [userDefaults stringForKey:@"password"];
    
    _ipTextField.text       = ip;
    _passwordTextField.text = password;
}

#pragma mark - Public Methods

- (IBAction)saveAction:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_ipTextField.text forKey:@"ip"];
    [userDefaults setObject:_passwordTextField.text forKey:@"password"];
    [userDefaults synchronize];
    
    if (_delegate) {
        [_delegate configurationDidChanged];
    }
}

- (IBAction)cancelAction:(id)sender {
    if (_delegate) {
        [_delegate needsDismissConfiguration];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _ipTextField) {
        [_passwordTextField becomeFirstResponder];
        return NO;
    }
    else {
        [textField resignFirstResponder];
        return YES;
    }
}

@end