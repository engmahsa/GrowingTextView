//
//  TextInPutView.h
//  Created by Mahsa
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "containerView.h"


@interface TextInPutView : UIView <UIGestureRecognizerDelegate>

- (void)initialize;

@property (weak, nonatomic) IBOutlet containerView *  textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textInputTop;

@end
