//
//  containerView.m
//  customTextView
//
//  Created by Mahsa.


#import "containerView.h"
#import "customTextView.h"
@interface containerView () <UITextViewDelegate,customTextViewDelegate> {
    
    customTextView *internalTextView;
    int minHeight;
    int maxHeight;
    int maxNumberOfLines;
    int minNumberOfLines;
    BOOL animateHeightChange;
    NSTimeInterval animationDuration;
    NSTextAlignment textAlignment;
    NSRange selectedRange;
    BOOL editable;
    UIDataDetectorTypes dataDetectorTypes;
    UIReturnKeyType returnKeyType;
    UIKeyboardType keyboardType;
    UIEdgeInsets contentInset;
}

@end

@interface containerView(private)
-(void)commonInitialiser;
-(void)resizeTextView:(NSInteger)newSizeH;
@end

@implementation containerView
@synthesize internalTextView;
@synthesize customDelegate;
@synthesize font;
@synthesize textColor;
@synthesize textAlignment;
@synthesize selectedRange;
@synthesize editable;
@synthesize returnKeyType;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInitialiser];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInitialiser];
    }
    return self;
}
-(void)commonInitialiser {
    [self commonInitialiser:nil];
}

-(void)commonInitialiser:(NSTextContainer *)textContainer
{
    // Initialization code
    CGRect tmpFrame = self.frame;
    tmpFrame.origin.y = 0;
    tmpFrame.origin.x = 0;
    internalTextView = [[customTextView alloc] initWithFrame:tmpFrame textContainer:textContainer];
    internalTextView.delegate = self;
    internalTextView.textInternalViewDelegate = self;
    internalTextView.scrollEnabled = NO;
    internalTextView.font = [UIFont systemFontOfSize:16];
    internalTextView.contentInset = UIEdgeInsetsZero;
    internalTextView.showsHorizontalScrollIndicator = NO;
    internalTextView.text = @"-";
    internalTextView.contentMode = UIViewContentModeRedraw;
    [self addSubview:internalTextView];
    
    minHeight = self.internalTextView.frame.size.height;
    minNumberOfLines = 1;
    animateHeightChange = YES;
    animationDuration = 0.1f;
    internalTextView.text = @"";
    [self setMaxNumberOfLines:3];
}

-(CGSize)sizeThatFits:(CGSize)size
{
    if (self.text.length == 0) {
        size.height = minHeight;
    }
    return size;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect tmpRect = self.bounds;
    tmpRect.origin.y = 0;
    tmpRect.origin.x = contentInset.left;
    tmpRect.size.width -= contentInset.left + contentInset.right;
    
    internalTextView.frame = tmpRect;
}

-(void)setContentInset:(UIEdgeInsets)inset
{
    contentInset = inset;
    CGRect tmpRect = self.frame;
    tmpRect.origin.y = inset.top - inset.bottom;
    tmpRect.origin.x = inset.left;
    tmpRect.size.width -= inset.left + inset.right;
    internalTextView.frame = tmpRect;
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIEdgeInsets)contentInset
{
    return contentInset;
}

-(void) setMaxNumberOfLines:(int)n
{
    if(n == 0 && maxHeight > 0) return;
    NSString *saveText = internalTextView.text;
    NSString *newText =  @"-";
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < n; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    maxHeight = [self calculateHeight];
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    
    [self sizeToFit];
    
    maxNumberOfLines = n;
}

-(int)maxNumberOfLines
{
    return maxNumberOfLines;
}

- (void)setMaxHeight:(int)height
{
    maxHeight = height;
    maxNumberOfLines = 0;
}

-(void)setMinNumberOfLines:(int)m
{
    if(m == 0 && minHeight > 0) return;
    NSString *saveText = internalTextView.text, *newText = @"-";
    internalTextView.delegate = nil;
    internalTextView.hidden = YES;
    
    for (int i = 1; i < m; ++i)
        newText = [newText stringByAppendingString:@"\n|W|"];
    
    internalTextView.text = newText;
    minHeight = [self calculateHeight];
    internalTextView.text = saveText;
    internalTextView.hidden = NO;
    internalTextView.delegate = self;
    [self sizeToFit];
    minNumberOfLines = m;
}

-(int)minNumberOfLines
{
    return minNumberOfLines;
}

- (void)setMinHeight:(int)height
{
    minHeight = height;
    minNumberOfLines = 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self refreshHeight];
}

- (void)refreshHeight
{
    [self.internalTextView setFont:[UIFont systemFontOfSize:16]];
    NSInteger newSizeH = [self calculateHeight];
    if (newSizeH < minHeight || !internalTextView.hasText) {
        newSizeH = minHeight;
    }
    else if (maxHeight && newSizeH > maxHeight) {
        newSizeH = maxHeight;
    }
    
    if (internalTextView.frame.size.height != newSizeH)
    {
        if (newSizeH >= maxHeight)
        {
            if(!internalTextView.scrollEnabled){
                internalTextView.scrollEnabled = YES;
                [internalTextView flashScrollIndicators];
            }
            
        } else {
            internalTextView.scrollEnabled = NO;
        }

        if (newSizeH <= maxHeight)
        {
            if(animateHeightChange) {
                    [UIView beginAnimations:@"" context:nil];
                    [UIView setAnimationDuration:animationDuration];
                    [UIView setAnimationDelegate:self];
                    [UIView setAnimationBeginsFromCurrentState:YES];
                    [self resizeTextView:newSizeH];
                    [UIView commitAnimations];
            } else {
                [self resizeTextView:newSizeH];
            }
        }
    }
}

- (CGFloat)calculateHeight
{
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        CGRect frame = self.internalTextView.bounds;
        UIEdgeInsets textContainerInsets = self.internalTextView.textContainerInset;
        UIEdgeInsets contentInsets = self.internalTextView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + self.internalTextView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        //////use attributed text instead of normal text if you want to parse some special character in text
        NSAttributedString *textToMeasure = self.internalTextView.attributedText;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return self.internalTextView.contentSize.height;
    }
    
}

-(void)resizeTextView:(NSInteger)newSizeH
{
    if ([customDelegate respondsToSelector:@selector(customTextView:willChangeHeight:)]) {
        [customDelegate customTextView:self willChangeHeight:newSizeH];
    }
    
    CGRect internalTextViewFrame = self.frame;
    internalTextViewFrame.size.height = newSizeH;
    self.frame = internalTextViewFrame;
    
    internalTextViewFrame.origin.y = contentInset.top - contentInset.bottom;
    internalTextViewFrame.origin.x = contentInset.left;
    
    if(!CGRectEqualToRect(internalTextView.frame, internalTextViewFrame)) internalTextView.frame = internalTextViewFrame;
}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    return [self.internalTextView becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    return [internalTextView resignFirstResponder];
}

-(BOOL)isFirstResponder
{
    return [self.internalTextView isFirstResponder];
}

-(void)setText:(NSString *)newText
{
    internalTextView.text = newText;
}

-(NSString*) text
{
    return internalTextView.text;
}

-(void)setFont:(UIFont *)afont
{
    internalTextView.font= afont;
    
    [self setMaxNumberOfLines:maxNumberOfLines];
    [self setMinNumberOfLines:minNumberOfLines];
}

-(UIFont *)font
{
    return internalTextView.font;
}

-(void)setTextColor:(UIColor *)color
{
    internalTextView.textColor = color;
}

-(UIColor*)textColor{
    return internalTextView.textColor;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    internalTextView.backgroundColor = backgroundColor;
}

-(UIColor*)backgroundColor
{
    return internalTextView.backgroundColor;
}

-(void)setTextAlignment:(NSTextAlignment)aligment
{
    internalTextView.textAlignment = aligment;
}

-(NSTextAlignment)textAlignment
{
    return internalTextView.textAlignment;
}

-(void)setSelectedRange:(NSRange)range
{
    internalTextView.selectedRange = range;
}

-(NSRange)selectedRange
{
    return internalTextView.selectedRange;
}

- (void)setIsScrollable:(BOOL)isScrollable
{
    internalTextView.scrollEnabled = isScrollable;
}

- (BOOL)isScrollable
{
    return internalTextView.scrollEnabled;
}

-(void)setEditable:(BOOL)beditable
{
    internalTextView.editable = beditable;
}

-(BOOL)isEditable
{
    return internalTextView.editable;
}

-(void)setReturnKeyType:(UIReturnKeyType)keyType
{
    internalTextView.returnKeyType = keyType;
}

-(UIReturnKeyType)returnKeyType
{
    return internalTextView.returnKeyType;
}

- (void)setKeyboardType:(UIKeyboardType)keyType
{
    internalTextView.keyboardType = keyType;
}

- (UIKeyboardType)keyboardType
{
    return internalTextView.keyboardType;
}

- (void)setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically
{
    internalTextView.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
}

- (BOOL)enablesReturnKeyAutomatically
{
    return internalTextView.enablesReturnKeyAutomatically;
}

-(UIDataDetectorTypes)dataDetectorTypes
{
    return internalTextView.dataDetectorTypes;
}

- (BOOL)hasText{
    return [internalTextView hasText];
}

- (void)scrollRangeToVisible:(NSRange)range
{
    [internalTextView scrollRangeToVisible:range];
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
        return YES;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)pastHappendOnTextView{
    
    [self refreshHeight];
}

-(void)setResponder:(UIResponder *)responder
{
    ((customTextView*)self.internalTextView).inputNextResponder = responder;
    
}
@end
