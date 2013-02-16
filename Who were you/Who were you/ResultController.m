//
//  ResultController.m
//  Who were you
//
//  Created by Sheen Vempeny on 11/14/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "ResultController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"
#import "AppDelegate.h"




@implementation ResultController


@synthesize pastLife;
@synthesize images;
@synthesize navigationBar;
@synthesize animalSoundPlayer;
@synthesize menuPopoverController;
@synthesize mMenuViewController;
@synthesize mFaceBookViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        
    NSMutableArray *imageArray=[NSMutableArray array];
    [imageArray addObject:[UIImage imageNamed:@"Bee.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Bear.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Cat.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Cow.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Deer.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Dog.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Duck.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Elephant.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Penguin.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Frog.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Giraffe.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Hippopotamus.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Horse.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Lion.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Monkey.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Parrot.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Rabbit.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Rooster.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Sheep.png"]];
    [imageArray addObject:[UIImage imageNamed:@"Tiger.png"]];
    
    self.images = imageArray;
    imageNumber = 0;
    
  AppDelegate  *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
            }];
        }
    }
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)find
{
    [activityIndicator stopAnimating];
    activityIndicator.hidden=YES;
    saveImageStatus.hidden=YES;
    
    [currentImageView setImage:[pastLife.currentImage resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES]];
    
    [self animateImage];
    [pastLabel setText:@"Finding..."];
    [titleItem setTitle:@"Finding..."];
    [currentLabel setText:[NSString stringWithFormat:@"%@ %@",pastLife.firstName,pastLife.lastName]];
    
}

-(IBAction)back:(id)sender
{
    
    if(self.mFaceBookViewController.view.superview){
        [self removeFacebookView];
    }
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        if(self.mMenuViewController.view.superview)
        [self cancelClicked];
    }
    
    [self dismissViewControllerAnimated:YES completion:^(){
        //put your code here
        
    }];
    
    [currentImageView setImage:nil];
    [pastImageView setImage:nil];
}

-(void) animateImage;
{
    
    activityIndicator.hidden=YES;
    [activityIndicator stopAnimating];
    
    NSMutableArray *animationSequenceArray = [NSMutableArray array];
    for (UIImage *image in self.images) {
        UIImage *_imageToProcess=[image resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES];
        [animationSequenceArray addObject:(id)_imageToProcess.CGImage]; //<--Does this have to be (id)image.CGImage ?, if I am correct you are unable to add CGImage to an array
    }
    
   
    CAKeyframeAnimation *countanimation = [CAKeyframeAnimation animation];
    [countanimation setKeyPath:@"contents"];
    [countanimation setValues:animationSequenceArray];
    [countanimation setFillMode:kCAFillModeBoth];
    [countanimation setCalculationMode:kCAAnimationDiscrete];
    [countanimation setDuration:1.0f];
    [countanimation setDelegate:self];
    [countanimation setAutoreverses:NO];
    [countanimation setRemovedOnCompletion:YES];
    [countanimation setValue:@"Countdown" forKey:@"name"];
    [pastImageView.layer addAnimation:countanimation forKey:nil];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([[anim valueForKey:@"name"] isEqual:@"Countdown"])
    {
        UIImage *pastImage=[self.images objectAtIndex:pastLife.uniqueNumber];
//        if(pastImage.size.height > pastImageView.bounds.size.height || pastImage.size.width > pastImageView.bounds.size.width)
//            [pastImageView setImage:[UIImage imageWithImage:[self.images objectAtIndex:pastLife.uniqueNumber] scaledToSize:currentImageView.bounds.size]];
//        else
//            [pastImageView setImage:pastImage];
        
        [pastImageView setImage:[pastImage resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES]];
        
        pastLife.pastLifeImage=pastImage;
        
        [titleItem setTitle:[NSString stringWithFormat:@"%@ %@",@"You were a",[self nameForIndex:pastLife.uniqueNumber]]];
        [pastLabel setText:[NSString stringWithFormat:@"%@ %@",@"You were a",[self nameForIndex:pastLife.uniqueNumber]]];
        NSString *backgroundFilePath=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",[self nameForIndex:pastLife.uniqueNumber],@"Sound"] ofType:@"mp3"];
        
        if(backgroundFilePath){
            
            NSURL *url = [NSURL fileURLWithPath:backgroundFilePath];
            NSError *error;
            self.animalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] ;
            self.animalSoundPlayer .numberOfLoops = 0;
            [self.animalSoundPlayer play];
            
            
        }
    }
}


-(NSString*)nameForIndex:(NSInteger)index
{
    
    switch (index) {
        case 0:
            return @"Bee";
            break;
        case 1:
            return @"Bear";
            break;
        case 2:
            return @"Cat";
            break;
        case 3:
            return @"Cow";
            break;
        case 4:
            return @"Deer";
            break;
        case 5:
            return @"Dog";
            break;
        case 6:
            return @"Duck";
            break;
        case 7:
            return @"Elephant";
            break;
        case 8:
            return @"Penguin";
            break;
        case 9:
            return @"Frog";
            break;
        case 10:
            return @"Giraffe";
            break;
        case 11:
            return @"Hippopotamus";
            break;
        case 12:
            return @"Horse";
            break;
        case 13:
            return @"Lion";
            break;
        case 14:
            return @"Monkey";
            break;
        case 15:
            return @"Parrot";
            break;
        case 16:
            return @"Rabbit";
            break;
        case 17:
            return @"Rooster";
            break;
        case 18:
            return @"Sheep";
            break;
        case 19:
            return @"Tiger";
            break;
            
        default:
            break;
    }
    
    
    return @"";
    
}

-(IBAction)showMenu:(id)sender
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        
        if(!menuPopoverController)
        {
            MenuViewController *_mMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
            _mMenuViewController.delegate = self;
            menuPopoverController =[[UIPopoverController alloc] initWithContentViewController:_mMenuViewController];
            //	[mMenuViewController release];
            
        }
        
        if(!menuPopoverController.popoverVisible)
        {
            //setting pop over size,
            [menuPopoverController setPopoverContentSize: CGSizeMake(280,144)];
            CGRect buttonFrame = CGRectZero;
            buttonFrame.origin.x = self.view.bounds.size.width-10.0;
            buttonFrame.origin.y = 20.0;
            buttonFrame.size.width=2.0;
            buttonFrame.size.height=2.0;
            [menuPopoverController presentPopoverFromRect:buttonFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
        }
        
        
    }
    else{
        
        if(!self.mMenuViewController)
        {
            self.mMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController-iPhone" bundle:[NSBundle mainBundle]];
            mMenuViewController.delegate = self;
        }
        
        mMenuViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height ,mMenuViewController.view.bounds.size.width , mMenuViewController.view.bounds.size.height);
        [self applyShinyBackgroundWithColor:[UIColor colorWithRed:110.0/255.0 green:50.0/255.0 blue:32.0/255.0 alpha:1.0] forView:mMenuViewController.view];
        [self.view addSubview:self.mMenuViewController.view];
        
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        mMenuViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height-mMenuViewController.view.bounds.size.height ,mMenuViewController.view.bounds.size.width , mMenuViewController.view.bounds.size.height);
        //notice this is ON screen!
        [UIView commitAnimations];
        
    }
    
}


- (void)applyShinyBackgroundWithColor:(UIColor *)color forView:(UIView*)newView{
    
    // create a CAGradientLayer to draw the gradient on
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    // get the RGB components of the color
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    
    // create the colors for our gradient based on the color passed in
    layer.colors = [NSArray arrayWithObjects:
                    (id)[color CGColor],
                    (id)[[UIColor colorWithRed:0.98f*cs[0]
                                         green:0.98f*cs[1]
                                          blue:0.98f*cs[2]
                                         alpha:0.5] CGColor],
                    (id)[[UIColor colorWithRed:0.95f*cs[0]
                                         green:0.95f*cs[1]
                                          blue:0.95f*cs[2]
                                         alpha:0.6] CGColor],
                    (id)[[UIColor colorWithRed:0.93f*cs[0]
                                         green:0.93f*cs[1]
                                          blue:0.93f*cs[2]
                                         alpha:0.7] CGColor],
                    nil];
    
    // create the color stops for our gradient
    layer.locations = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.0f],
                       [NSNumber numberWithFloat:0.49f],
                       [NSNumber numberWithFloat:0.51f],
                       [NSNumber numberWithFloat:1.0f],
                       nil];
    
    layer.frame = newView.bounds;
    [newView.layer insertSublayer:layer atIndex:0];
}

-(void)shareToFacebookClicked
{
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self cancelClicked];
        [self performSelector:@selector(showFaceBookView) withObject:nil afterDelay:0.55];
       
    }
    else{
        [menuPopoverController dismissPopoverAnimated:YES];
         [self showFaceBookView];
    }

}

-(void)saveToPhotoAlbumClicked
{
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self cancelClicked];
    }
    else{
        [menuPopoverController dismissPopoverAnimated:YES];
    }
    [activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	[saveImageStatus setHidden:NO];

    UIImage *reconstructedImage=[self createFinalImage];
    UIImageWriteToSavedPhotosAlbum(reconstructedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
	

}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
	UIAlertView *message;
	
	if(error != nil) {
		message = [[UIAlertView alloc] initWithTitle:@"Who were you"
											  message:@"Error in saving photo"
											 delegate:nil
									cancelButtonTitle:@"OK"
									otherButtonTitles:nil] ;
	}
	else{
		
		message = [[UIAlertView alloc] initWithTitle:@"Who were you"
											  message:@"Image saved to photo album"
											 delegate:nil
									cancelButtonTitle:@"OK"
									otherButtonTitles:nil] ;
	}
	
	
	[message show];
	
	[activityIndicator setHidden:YES];
	[activityIndicator stopAnimating];
	[saveImageStatus setHidden:YES];
    
}


-(void)cancelClicked
{
    [self.mMenuViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    NSTimeInterval animationDuration = 0.4; /* determine length of animation */;
    CGRect newFrameSize = CGRectMake(0.0,self.view.bounds.size.height ,self.mMenuViewController.view.bounds.size.width , self.mMenuViewController.view.bounds.size.height); /* determine what the frame size should be */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.mMenuViewController.view.frame = newFrameSize;
    [UIView commitAnimations];
    
    
}


-(void)showFaceBookView
{
    
    if(!self.mFaceBookViewController)
    {
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            self.mFaceBookViewController = [[FaceBookViewController alloc] initWithNibName:@"FaceBookViewController-iPad" bundle:[NSBundle mainBundle]];
            
        }
        else{
            
            self.mFaceBookViewController = [[FaceBookViewController alloc] initWithNibName:@"FaceBookViewController" bundle:[NSBundle mainBundle]];
        }
       
    }
    self.mFaceBookViewController.delegate=self;
    self.mFaceBookViewController.imageToUpload=[self createFinalImage];
    self.mFaceBookViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height ,self.mFaceBookViewController.view.bounds.size.width , self.mFaceBookViewController.view.bounds.size.height);
    [self applyShinyBackgroundWithColor:[UIColor colorWithRed:110.0/255.0 green:50.0/255.0 blue:32.0/255.0 alpha:1.0] forView:self.mFaceBookViewController.view];
    [self.view addSubview:self.mFaceBookViewController.view];
    
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.4];
    self.mFaceBookViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height-self.mFaceBookViewController.view.bounds.size.height ,self.mFaceBookViewController.view.bounds.size.width , self.mFaceBookViewController.view.bounds.size.height);
    //notice this is ON screen!
    [UIView commitAnimations];
    


}

-(void)removeFacebookView
{
   
    [self.mFaceBookViewController.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
    NSTimeInterval animationDuration = 0.4; /* determine length of animation */;
    CGRect newFrameSize = CGRectMake(0.0,self.view.bounds.size.height ,self.mFaceBookViewController.view.bounds.size.width , self.mFaceBookViewController.view.bounds.size.height); /* determine what the frame size should be */
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    self.mFaceBookViewController.view.frame = newFrameSize;
    [UIView commitAnimations];
  
}

-(UIImage*)createFinalImage
{
    CGSize _size=CGSizeMake(1000.0, 500.0);
    // create screen dump of the view of this view controller
    UIGraphicsBeginImageContext(_size);
   
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
		UIGraphicsBeginImageContextWithOptions(_size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(_size);
    }

    CGRect firstRect=CGRectMake(5.0, 50.0, 490.0, 430.0);
    CGRect secondRect=CGRectMake(505.0, 50.0, 490.0, 430.0);
    
    UIImage *pastImage=[pastLife.pastLifeImage resizedImageToFitInSize:firstRect.size scaleIfSmaller:YES];
    [pastImage drawInRect:firstRect];
  
    UIImage *currentImage=[pastLife.currentImage resizedImageToFitInSize:secondRect.size scaleIfSmaller:YES];
    [currentImage drawInRect:secondRect];
    CGRect firstLetterRect=CGRectMake(5.0, 5.0, 490.0, 40.0);
    [[NSString stringWithFormat:@"%@ %@",@"You were a",[self nameForIndex:pastLife.uniqueNumber]] drawInRect:firstLetterRect withFont:[UIFont boldSystemFontOfSize:20.0] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    CGRect secondLetterRect=CGRectMake(505.0, 5.0, 490.0, 40.0);
    [[NSString stringWithFormat:@"%@ %@",pastLife.firstName,pastLife.lastName]  drawInRect:secondLetterRect withFont:[UIFont boldSystemFontOfSize:20.0] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    //drawing tail string
    CGRect tailRect=CGRectMake(5.0,480.0 , 950.0, 20.0);
    [@"Created By Who Were you. More apps visit www.iphoneapp4fun.com" drawInRect:tailRect withFont:[UIFont boldSystemFontOfSize:15.0] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];

    UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
  
     UIGraphicsEndImageContext();
    
    return screenShot;
}



@end
