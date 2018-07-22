//
//  TextInPutView.m
//  Created by Mahsa.

#import "TextInPutView.h"
#import <AVFoundation/AVFoundation.h>


@implementation TextInPutView

-(void)initialize {
    
    self.textInputTop.constant = 0;
    self.  textView.isScrollable = NO;
    self.  textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.  textView.clipsToBounds = YES;
    self.  textView.layer.cornerRadius = 8.0f;
    self.  textView.layer.borderWidth = 1.0;
    [self.  textView.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    self.  textView.minNumberOfLines = 1;
    self.  textView.maxNumberOfLines = 6;
    self.  textView.returnKeyType = UIReturnKeyDefault;
    self.  textView.font = [UIFont systemFontOfSize:16];
    self.  textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.  textView.backgroundColor = [UIColor whiteColor];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)becomeFirstResponder
{
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if (action == @selector(copy:))
        return YES;
    else if (action == @selector(paste:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}
- (IBAction)sendButtonPressed:(id)sender {
    NSLog(@"Send Message");
}

@end
