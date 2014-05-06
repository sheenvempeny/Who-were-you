//
//  ResultController.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/14/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastLife.h"
#import "SCNavigationBar.h"
#import <AVFoundation/AVFoundation.h>
#import "MenuViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FaceBookViewController.h"

@interface ResultController : UIViewController <MenuViewDelegate>
{
    
    IBOutlet UINavigationItem *titleItem;
    IBOutlet UIBarButtonItem *titleButton;
    IBOutlet UIImageView *currentImageView;
    IBOutlet UIImageView *pastImageView;
    IBOutlet UILabel *pastLabel;
    IBOutlet SCNavigationBar *navigationBar;
    IBOutlet UILabel *currentLabel;
    
    PastLife *pastLife;
    
    NSInteger imageNumber;
    AVAudioPlayer *animalSoundPlayer;
  
	UIPopoverController *menuPopoverController;
    MenuViewController *mMenuViewController;
    FaceBookViewController *mFaceBookViewController;
    
    SLComposeViewController *mySLComposerSheet;
    BOOL faceBookStatus;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    IBOutlet UILabel *saveImageStatus;
}

@property(nonatomic,retain)  FaceBookViewController *mFaceBookViewController;
@property(nonatomic,retain) MenuViewController *mMenuViewController;
@property (nonatomic, retain) UIPopoverController *menuPopoverController;
@property(nonatomic,retain) AVAudioPlayer *animalSoundPlayer;
@property(nonatomic,retain) UINavigationBar *navigationBar;
@property(nonatomic,retain) PastLife *pastLife;

-(IBAction)showMenu:(id)sender;
-(IBAction)back:(id)sender;
-(void)find;
-(void)showFaceBookView;


@end
