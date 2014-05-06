//
//  FBUploadView.m
//  Who were you
//
//  Created by Sheen Vempeny on 12/1/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "FBUploadView.h"

static NSString *const FBFBUploadViewCacheIdentity = @"FBUploadView";
const int kButtonLabelX2 = 46;

CGSize g_imageSize;

@interface FBUploadView() <UIActionSheetDelegate>

- (void)initialize;
- (void)buttonPressed:(id)sender;

@property (retain, nonatomic) UILabel *label;
@property (retain, nonatomic) UIButton *button;

@end


@implementation FBUploadView

@synthesize label = _label,
button = _button;
@synthesize delegate;
@synthesize text;
@synthesize tag;
@synthesize enabled;


-(void)setEnabled:(BOOL)inEnabled
{
    
    self.button.enabled = inEnabled;
    enabled=inEnabled;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initialize {
    // the base class can cause virtual recursion, so
    // to handle this we make initialize idempotent
    if (self.button) {
        return;
    }
    
    // setup view
    self.autoresizesSubviews = YES;
    self.clipsToBounds = YES;
    
      
    // setup button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self
                    action:@selector(buttonPressed:)
          forControlEvents:UIControlEventTouchUpInside];
    self.button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIImage *image = [[UIImage imageNamed:@"login-button-small.png"]
                      stretchableImageWithLeftCapWidth:kButtonLabelX2 topCapHeight:0];
    g_imageSize = image.size;
    [self.button setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [[UIImage imageNamed:@"login-button-small-pressed.png"]
             stretchableImageWithLeftCapWidth:kButtonLabelX2 topCapHeight:0];
    [self.button setBackgroundImage:image forState:UIControlStateHighlighted];
    
    [self addSubview:self.button];
    
    // add a label that will appear over the button
    self.label = [[UILabel alloc] init];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.label.textAlignment = UITextAlignmentCenter;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.font = [UIFont boldSystemFontOfSize:16.0];
    self.label.textColor = [UIColor whiteColor];
    self.label.shadowColor = [UIColor blackColor];
    self.label.shadowOffset = CGSizeMake(0.0, -1.0);
    self.label.text=self.text;
    [self addSubview:self.label];
    
    // We force our height to be the same as the image, but we will let someone make us wider
    // than the default image.
    CGFloat width = MAX(self.frame.size.width, g_imageSize.width);
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                              width, image.size.height);
    self.frame = frame;
    
    CGRect buttonFrame = CGRectMake(0, 0, width, image.size.height);
    self.button.frame = buttonFrame;
    
    self.label.frame = CGRectMake(kButtonLabelX2, 0, width - kButtonLabelX2, image.size.height);
    
    self.backgroundColor = [UIColor clearColor];
    
}
- (NSString *)logInText {
    return self.text;
}

- (NSString *)logOutText {
	return self.text;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize logInSize = [[self logInText] sizeWithFont:self.label.font];
    CGSize logOutSize = [[self logOutText] sizeWithFont:self.label.font];
    
    // Leave at least a small margin around the label.
    CGFloat desiredWidth = kButtonLabelX2 + 20 + MAX(logInSize.width, logOutSize.width);
    // Never get smaller than the image
    CGFloat width = MAX(desiredWidth, g_imageSize.width);
    
    return CGSizeMake(width, g_imageSize.height);
}



- (void)buttonPressed:(id)sender {
    
    if(self.tag==1)
        [delegate uploadPhoto];
    else if(self.tag==2)
        [delegate cancelled];
}

@end
