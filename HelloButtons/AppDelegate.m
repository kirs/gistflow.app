//
//  AppDelegate.m
//  HelloButtons
//
//  Created by Kirill Shatrov on 8/7/12.
//  Copyright (c) 2012 Kirill Shatrov. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)showPublishWindow:(id)sender {
    [window orderFront:self];
    [window makeKeyWindow];
}
@end
