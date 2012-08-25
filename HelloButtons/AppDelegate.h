//
//  AppDelegate.h
//  HelloButtons
//
//  Created by Kirill Shatrov on 8/7/12.
//  Copyright (c) 2012 Kirill Shatrov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (IBAction)showPublishWindow:(id)sender;

@end
