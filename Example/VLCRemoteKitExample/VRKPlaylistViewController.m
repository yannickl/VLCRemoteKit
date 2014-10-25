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

#import "VRKPlaylistViewController.h"
#import "VLCRemoteKit.h"

@interface VRKPlaylistViewController () <VLCRemoteDelegate>

@end

@implementation VRKPlaylistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playlist.delegate = self;
}

- (IBAction)doneAction:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - VLCRemote Delegate Methods

- (void)remoteObjectDidChanged:(id<VLCRemoteProtocol>)remote
{
    [_tableView reloadData];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_playlist.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VRKPlaylistCell"];
    
    VLCPlaylistItem *item = [_playlist.items objectAtIndex:indexPath.row];
                             
    cell.textLabel.text = [item name];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate) {
        VLCPlaylistItem *item = [_playlist.items objectAtIndex:indexPath.row];
        
        [_delegate itemDidSelected:item];
    }
    else {
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

@end
