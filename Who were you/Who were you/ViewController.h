//
//  ViewController.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/2/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastLife.h"
#import "ResultController.h"
#import "SCNavigationBar.h"

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIToolbar *_accessoryView;
    IBOutlet UIDatePicker *_customInput;
    IBOutlet UITextField *firstNameTxt;
    IBOutlet UITextField *lastNameTxt;
    IBOutlet UITextField *dobTextField;
    IBOutlet UIImageView *mUIImageView;
    
    IBOutlet UIView *resultView;
    UIPopoverController *popOver;
    UIImage *currentImage;
    ResultController *mResultController;
    IBOutlet SCNavigationBar *navigationBar;
}
@property(nonatomic,retain) ResultController *mResultController;
@property (nonatomic, retain) UIImage *currentImage;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) IBOutlet UITextField *firstNameTxt;
@property (nonatomic, retain) IBOutlet UITextField *lastNameTxt;
@property (nonatomic, retain) IBOutlet UITextField *dobTextField;
@property (nonatomic, retain) IBOutlet UIImageView *mUIImageView;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
@property (nonatomic, retain) IBOutlet UIDatePicker *customInput;

-(IBAction)dateChanged:(id)sender;
-(IBAction)doneEditing:(id)sender;
-(IBAction)openPhotoFromLibrary:(id)sender;
-(IBAction)openPhotoFromCamera:(id)sender;
-(void)loadResultViewController:(PastLife*)inPastLife;
-(IBAction)clear:(id)sender;
@end
