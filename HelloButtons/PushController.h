//
//  PushController.h
//  HelloButtons
//
//  Created by Kirill Shatrov on 8/9/12.
//  Copyright (c) 2012 Kirill Shatrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushController : NSObject <NSURLConnectionDelegate> {
    IBOutlet NSMenu *statusMenu;
    NSStatusItem * statusItem;
}

@property (strong) NSString *authKey;
@property BOOL isPrivate;

@property (strong) IBOutlet NSTextView *codeField;
@property (strong) IBOutlet NSTextField *titleField;
@property (strong) IBOutlet NSButton *publishButton;
@property (strong) IBOutlet NSProgressIndicator *publishProgressIndicator;
@property (strong) IBOutlet NSTextField *copiedNotice;

- (IBAction)publish:(id)sender;
- (void)copyToClipboard:(NSString *)value;

@end
