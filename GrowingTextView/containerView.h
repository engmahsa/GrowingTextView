//
//  containerView.h
//  customTextView
//
//  Created by Mahsa

#import <UIKit/UIKit.h>
#import "customTextView.h"


@class containerView;
@class customTextView;

@protocol containerViewcustomDelegate
@optional

- (void)customTextView:(containerView *)customTextView willChangeHeight:(float)height;

@end

@interface containerView : UIView <UITextViewDelegate,customTextViewDelegate> 

//real class properties
@property int maxNumberOfLines;
@property int minNumberOfLines;
@property (nonatomic, strong) UITextView *internalTextView;

//uitextview properties
@property(unsafe_unretained) NSObject <containerViewcustomDelegate> *customDelegate;

@property(nonatomic,strong) NSString *text;
@property(nonatomic,strong) UIFont *font;
@property(nonatomic,strong) UIColor *textColor;
@property(nonatomic) NSTextAlignment textAlignment;
@property(nonatomic) NSRange selectedRange;
@property(nonatomic,getter=isEditable) BOOL editable;
@property (nonatomic) UIReturnKeyType returnKeyType;
@property (nonatomic) UIKeyboardType keyboardType;
@property (assign) UIEdgeInsets contentInset;
@property (nonatomic) BOOL isScrollable;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;

- (BOOL)becomeFirstResponder;

@end

