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
#import "Utilities.h"


@interface  ResultController()

@end


@implementation ResultController

@synthesize pastLife;
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
    imageNumber = 0;
    AppDelegate  *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) 
	{
        appDelegate.session = [[FBSession alloc] init];
        
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) 
		{
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) 
			 {
				 
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
	//Finding past life
    [activityIndicator stopAnimating];
    activityIndicator.hidden = YES;
    saveImageStatus.hidden = YES;
    [currentImageView setImage:[pastLife.currentImage resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES]];
	//Animating image
    [self animateImage];
    [pastLabel setText:@"Finding..."];
    [titleItem setTitle:@"Finding..."];
    [currentLabel setText:[NSString stringWithFormat:@"%@ %@",pastLife.firstName,pastLife.lastName]];
    
}

-(IBAction)back:(id)sender
{
    
    if(self.mFaceBookViewController.view.superview)
	{
        [self removeFacebookView];
    }
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        if(self.mMenuViewController.view.superview)
			[self cancelClicked];
    }
    
    [self dismissViewControllerAnimated:YES completion:^()
	{
        //put your code here
        
    }];
    
    [currentImageView setImage:nil];
    [pastImageView setImage:nil];
}

-(void) animateImage
{
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    NSMutableArray *animationSequenceArray = [NSMutableArray array];
    for (UIImage *image in [Utilities animalImages]) 
	{
        UIImage *_imageToProcess = [image resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES];
        [animationSequenceArray addObject:(id)_imageToProcess.CGImage]; 
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
        UIImage *pastImage = [[Utilities animalImages] objectAtIndex:pastLife.uniqueNumber];
        [pastImageView setImage:[pastImage resizedImageToFitInSize:currentImageView.bounds.size scaleIfSmaller:YES]];
        pastLife.pastLifeImage = pastImage;
		NSString *pastLifeName = [[Utilities animalNames] objectAtIndex:pastLife.uniqueNumber];
        [titleItem setTitle:[NSString stringWithFormat:@"%@ %@",@"You were a",pastLifeName]];
        [pastLabel setText:[NSString stringWithFormat:@"%@ %@",@"You were a",pastLifeName]];
        NSString *backgroundFilePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",pastLifeName,@"Sound"] ofType:@"mp3"];
        if(backgroundFilePath)
		{
			//playing animal sound
            NSURL *url = [NSURL fileURLWithPath:backgroundFilePath];
            NSError *error;
            self.animalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] ;
            self.animalSoundPlayer.numberOfLoops = 0;
            [self.animalSoundPlayer play];
		}
    }
}


-(IBAction)showMenu:(id)sender
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(!menuPopoverController)
        {
            MenuViewController *_mMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
            _mMenuViewController.delegate = self;
            menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:_mMenuViewController];
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
    else
	{
        if(!self.mMenuViewController)
        {
            self.mMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController-iPhone" bundle:[NSBundle mainBundle]];
            mMenuViewController.delegate = self;
        }
        
        mMenuViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height ,mMenuViewController.view.bounds.size.width , mMenuViewController.view.bounds.size.height);
        [Utilities applyShinyBackgroundWithColor:[UIColor colorWithRed:110.0/255.0 green:50.0/255.0 blue:32.0/255.0 alpha:1.0] forView:mMenuViewController.view];
        [self.view addSubview:self.mMenuViewController.view];
        //animating
        [UIView beginAnimations:@"animateTableView" context:nil];
        [UIView setAnimationDuration:0.4];
        mMenuViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height-mMenuViewController.view.bounds.size.height ,mMenuViewController.view.bounds.size.width , mMenuViewController.view.bounds.size.height);
        //notice this is ON screen!
        [UIView commitAnimations];
        
    }
    
}

-(void)shareToFacebookClicked
{
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self cancelClicked];
        [self performSelector:@selector(showFaceBookView) withObject:nil afterDelay:0.55];
		
    }
    else
	{
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
    else
	{
        [menuPopoverController dismissPopoverAnimated:YES];
    }
	
    [activityIndicator setHidden:NO];
	[activityIndicator startAnimating];
	[saveImageStatus setHidden:NO];
	UIImage *reconstructedImage=[Utilities createFinalImage:pastLife];
    UIImageWriteToSavedPhotosAlbum(reconstructedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
	
	
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo 
{
	UIAlertView *message = nil;
	
	if(error != nil) 
	{
		message = [[UIAlertView alloc] initWithTitle:@"Who were you"
											 message:@"Error in saving photo"
											delegate:nil
								   cancelButtonTitle:@"OK"
								   otherButtonTitles:nil] ;
	}
	else
	{
		
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
    self.mFaceBookViewController.delegate = self;
    self.mFaceBookViewController.imageToUpload = [Utilities createFinalImage:pastLife];
    self.mFaceBookViewController.view.frame = CGRectMake(0.0,self.view.bounds.size.height ,self.mFaceBookViewController.view.bounds.size.width , self.mFaceBookViewController.view.bounds.size.height);
    [Utilities applyShinyBackgroundWithColor:[UIColor colorWithRed:110.0/255.0 green:50.0/255.0 blue:32.0/255.0 alpha:1.0] forView:self.mFaceBookViewController.view];
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




@end
