//
//  MMTextInternalView.m
//  customTextView
//
//  Created by Mahsa .

#import "customTextView.h"

@interface customTextView ()

@end

@implementation customTextView
@synthesize textInternalViewDelegate;
@synthesize inputNextResponder;

-(void)setText:(NSString *)text
{
    BOOL originalValue = self.scrollEnabled;
    [self setScrollEnabled:YES];
    [super setText:text];
     self.font = [UIFont systemFontOfSize:16];
    [self setScrollEnabled:originalValue];
}

- (void)setScrollable:(BOOL)isScrollable
{
    [super setScrollEnabled:isScrollable];
}

-(void)setContentSize:(CGSize)contentSize
{
    if(self.contentSize.height > contentSize.height)
    {
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
    }

    [super setContentSize:contentSize];
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
    if (inputNextResponder != nil)
        return NO;
    if (action == @selector(copy:))
        return YES;
    else if (action == @selector(paste:))
        return YES;
    
    return [super canPerformAction:action withSender:sender];
}

- (UIResponder *)nextResponder {
    if (inputNextResponder != nil)
        return inputNextResponder;
    else
        return [super nextResponder];
}
- (void)copy:(id)sender
{
    NSLog(@"copy : %@" , [UIPasteboard generalPasteboard]);
    
    if (!self.selectedTextRange.isEmpty) {

        [[UIPasteboard generalPasteboard] setString:self.attributedText.string];
        
    }else{
        //////if nothing selected naturally copy nothing...
        [[UIPasteboard generalPasteboard] setString:@""];
    }
}

- (void)paste:(id)sender
{
    NSRange range = self.selectedRange;
    NSMutableAttributedString *strAtr = [[NSMutableAttributedString alloc] init];
    
    NSString *pastString = [[UIPasteboard generalPasteboard] string];
    
    if (pastString.length == 0) {
        
        
        //////nothing to past... :)
        
    }else{
        
        if (range.length > 0) {
        
            NSAttributedString *pastStr = [[NSAttributedString alloc] initWithString:pastString];
            
            [strAtr appendAttributedString:pastStr];
            
            range.location = range.location + range.length;
            range.length = 0;
            
        }else{
            
            NSAttributedString *pastStr = [[NSAttributedString alloc] initWithString:pastString];
            
            [strAtr appendAttributedString:pastStr];
            
            range.location = pastStr.length;
            range.length = 0;
        }
        
    }
    
    BOOL shouldChangeCursewrToEnd = NO;
    if (self.selectedRange.location == self.attributedText.length) {
        
        shouldChangeCursewrToEnd = YES;
    }
        
    self.attributedText = strAtr;
    
    if (shouldChangeCursewrToEnd) {
        
        self.selectedRange = NSMakeRange(strAtr.string.length, 0);
    }else{
        self.selectedRange = range;
    }
    
    [self.textInternalViewDelegate pastHappendOnTextView];
}


@end
