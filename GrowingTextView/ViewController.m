//
//  ViewController.m
//  AddExtraKeyBoard
//
//  Created by Mahsa .
//

#import "ViewController.h"
#import "TextInPutView.h"

@interface ViewController () < containerViewcustomDelegate > {
    TextInPutView                   *inputView;
}

@property (nonatomic, retain) UIView *TextInputViewNib;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerXibFiles];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)registerXibFiles{
    
    if (self.TextInputViewNib) {
        [self.TextInputViewNib removeFromSuperview];
        self.TextInputViewNib = nil;
    }
    
    NSArray* nbViews = [[NSBundle mainBundle] loadNibNamed:@"TextInPutView"
                                                     owner:self
                                                   options:nil];
    
    TextInPutView *inputTextView = [ nbViews objectAtIndex: 0];
    self.TextInputViewNib =[[UIView alloc] init];
    [inputTextView initialize];
    self.TextInputViewNib = inputTextView;
    ((TextInPutView*)self.TextInputViewNib).  textView.customDelegate = self ;
    CGRect toolBarFrame = self.TextInputViewNib.frame;
    UIDeviceOrientation nextOrientation = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation sori = [UIApplication sharedApplication].statusBarOrientation;
    if (nextOrientation == UIDeviceOrientationFaceUp && self.view.frame.size.width > self.view.frame.size.height && sori == UIInterfaceOrientationPortrait) {
        
        toolBarFrame.origin.y = self.view.frame.size.width-44;
        toolBarFrame.size.width =self.view.frame.size.height;
        toolBarFrame.size.height = 44;
        
    }else if ((nextOrientation == UIDeviceOrientationLandscapeLeft || nextOrientation == UIDeviceOrientationLandscapeRight) && self.view.frame.size.width < self.view.frame.size.height){
        
        toolBarFrame.origin.y = self.view.frame.size.width-44;
        toolBarFrame.size.width =self.view.frame.size.height;
        toolBarFrame.size.height = 44;
    }
    else{
        
        toolBarFrame.origin.y = self.view.frame.size.height-44;
        toolBarFrame.size.width =self.view.frame.size.width;
        toolBarFrame.size.height = 44;
    }
    self.TextInputViewNib.frame = toolBarFrame;
    [self.view addSubview:self.TextInputViewNib];
    inputTextView = nil;
    [((TextInPutView*)self.TextInputViewNib).  textView becomeFirstResponder];
}

-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.TextInputViewNib.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.TextInputViewNib.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = self.TextInputViewNib.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    self.TextInputViewNib.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

- (void)customTextView:(containerView *)customTextView willChangeHeight:(float)height
{
    float diff = (customTextView.frame.size.height - height);
    
    CGRect r = self.TextInputViewNib.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    self.TextInputViewNib.frame = r;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    [UIView animateWithDuration:0.1 animations:^{
        [((TextInPutView*)self.TextInputViewNib).  textView resignFirstResponder];
    }];

    UIInterfaceOrientation sori = [UIApplication sharedApplication].statusBarOrientation;
    /* handle textInPutView position in rotation
     */
    if (size.height == self.view.frame.size.height ) {

        double refW = self.view.frame.size.height;
        double refH = self.view.frame.size.width;

        if (sori == UIInterfaceOrientationPortrait) {
            refW = self.view.frame.size.width;
            refH = self.view.frame.size.height;
        }

        [self.TextInputViewNib removeFromSuperview];
        CGRect toolBarFrame = self.TextInputViewNib.frame;
        toolBarFrame.origin.y = refW - toolBarFrame.size.height;
        toolBarFrame.size.width =refH;
        self.TextInputViewNib.frame = toolBarFrame;

        [self.view addSubview:self.TextInputViewNib];

    }

    else
    {
        [self.TextInputViewNib removeFromSuperview];
        CGRect toolBarFrame = self.TextInputViewNib.frame;
        toolBarFrame.origin.y = self.view.frame.size.width - toolBarFrame.size.height;
        toolBarFrame.size.width =self.view.frame.size.height;
        self.TextInputViewNib.frame = toolBarFrame;
        [self.view addSubview:self.TextInputViewNib];

    }
}

@end
