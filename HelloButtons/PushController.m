//
//  PushController.m
//  HelloButtons
//
//  Created by Kirill Shatrov on 8/9/12.
//  Copyright (c) 2012 Kirill Shatrov. All rights reserved.
//

#import "PushController.h"

@implementation PushController
@synthesize codeField;
@synthesize titleField;
@synthesize publishButton;
@synthesize publishProgressIndicator;
@synthesize copiedNotice;

NSUserDefaults *defaults;
NSMutableData *receivedData;
NSPasteboard *pasteBoard;

-(void)awakeFromNib {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"Giftflow"];
    [statusItem setHighlightMode:YES];
    
    
    pasteBoard = [NSPasteboard generalPasteboard];
    defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults stringForKey:@"authKey"]) {
        NSLog(@"reading value from cache");
        self.authKey = [defaults stringForKey:@"authKey"];
    }
}

- (IBAction)publish:(id)sender {
    if([self.authKey length] > 0) {
        [defaults setValue:self.authKey forKey:@"authKey"];
        NSLog(@"Writing value");
    }
    
    [self sendJSON];
}

- (void)sendJSON {
    
    [publishButton setEnabled:NO];
    [publishProgressIndicator setHidden:NO];
    
    NSString *serializedIsPrivate;
    if(self.isPrivate) {
        serializedIsPrivate = @"1";
    }
    else {
        serializedIsPrivate = @"0";
    }
    
    NSString* gistCode = [[codeField textStorage] string];
    NSString* gistTitle = [titleField stringValue];
    
    NSArray *objects = [NSArray arrayWithObjects: gistTitle, gistCode, serializedIsPrivate, nil];
    NSArray *keys = [NSArray arrayWithObjects: @"title", @"content", @"is_private", nil];
    NSDictionary *questionDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithObject:questionDict forKey:@"post"];
    
    [jsonDict setValue: self.authKey forKey:@"token"];
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonRequest is %@", jsonString);

    
    NSURL *url = [NSURL URLWithString:@"http://gistflow.com/posts"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:60.0];

    NSData *requestData = [NSData dataWithBytes:[jsonString UTF8String] length:[jsonString length]];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%ld", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    // все остальное делается через didReceiveData delegate
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [publishButton setEnabled:YES];
    [publishProgressIndicator setHidden:YES];
    [copiedNotice setHidden:YES];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"json response: %@", json);
    NSMutableArray* errors = [json objectForKey:@"errors"];
    
    if([errors count] > 0) {
        NSString *message;
        message = [errors componentsJoinedByString:@"\n"];
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:message];
        [alert runModal];
        
    }
    else {
        NSString* gistUrl = [json objectForKey:@"location"];
        [copiedNotice setHidden:NO];
        [self copyToClipboard:gistUrl];
    }

}

- (void) copyToClipboard:(NSString *)value
{
    [pasteBoard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    [pasteBoard setString:value forType:NSStringPboardType];
}
@end
