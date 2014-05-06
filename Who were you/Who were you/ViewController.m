//
//  ViewController.m
//  Who were you
//
//  Created by Sheen Vempeny on 11/2/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Resize.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize accessoryView = _accessoryView;
@synthesize customInput = _customInput;
@synthesize firstNameTxt;
@synthesize lastNameTxt;
@synthesize dobTextField;
@synthesize mUIImageView;
@synthesize popOver;
@synthesize currentImage;
@synthesize mResultController;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
	if (_accessoryView == nil) 
	{
		_accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [_accessoryView setBarStyle:UIBarStyleBlackTranslucent];
        
        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *aceptar = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(doneEditing:)];
        
        [_accessoryView setItems:[[NSArray alloc] initWithObjects: extraSpace, aceptar, nil]];
		_customInput = [[UIDatePicker alloc] init];
        _customInput.datePickerMode = UIDatePickerModeDate;
        [_customInput addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        self.dobTextField.inputView = self.customInput;
        self.dobTextField.inputAccessoryView = self.accessoryView;
        
        
    }
    
	
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateChanged:(id)sender 
{
    UIDatePicker *picker = (UIDatePicker *)sender;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *theDate = [dateFormat stringFromDate:picker.date];
    
    self.dobTextField.text = theDate;
    
}

- (IBAction)doneEditing:(id)sender {
    [self.dobTextField resignFirstResponder];
    UIDatePicker *picker = (UIDatePicker *)self.customInput;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *theDate = [dateFormat stringFromDate:picker.date];
    
    self.dobTextField.text = theDate;
    
}

-(IBAction)openPhotoFromLibrary:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
	{
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        self.popOver = popover;
    } else 
	{
        
        [self presentViewController:picker animated:YES completion:^(){
            //put your code here
        }];
        
    }
    
}
-(IBAction)openPhotoFromCamera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    
    @try
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
		{
            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [popover presentPopoverFromRect:[sender frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
            self.popOver = popover;
        } else
		{
            
            [self presentViewController:picker animated:YES completion:^(){
                //put your code here
            }];
        }
        
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Camera" message:@"Camera is not available  " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)setCurrentLifeImage:(NSDictionary*)info
{
	UIImage *myImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	self.currentImage = myImage;
	[mUIImageView setImage:[myImage resizedImageToFitInSize:self.mUIImageView.bounds.size scaleIfSmaller:YES]];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
	{
        [self.popOver dismissPopoverAnimated:true];
        //put your code here
		[self setCurrentLifeImage:info];
    }
    else
	{
        [picker dismissViewControllerAnimated:YES completion:^()
		{
            //put your code here
			[self setCurrentLifeImage:info];
        }];
        
    }
    
}

-(IBAction)find:(id)sender
{
	UIAlertView *alert = nil;
    NSString *firstName = [firstNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *lastName = [lastNameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	if(firstName.length == 0)//checking first name is empty or not
	{
		alert = [[UIAlertView alloc] initWithTitle:@"Who were you" message:@"Please enter your first name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	}
    else if(lastName.length == 0)//checking last name is empty or not
	{
		alert = [[UIAlertView alloc] initWithTitle:@"Who were you" message:@"Please enter your last name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
	else if( dobTextField.text.length == 0)
	{
		alert = [[UIAlertView alloc] initWithTitle:@"Who were you" message:@"Please select your date of birth" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
    else if(!mUIImageView.image)
	{
		alert = [[UIAlertView alloc] initWithTitle:@"Who were you" message:@"Please select your photo" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    }
	
	if(alert)
	{
		[alert show];
	}
	else
	{	
		PastLife *mPastLife = [PastLife new];
		mPastLife.firstName = firstName;
		mPastLife.lastName = lastName;
		mPastLife.dob = dobTextField.text;
		mPastLife.currentImage = self.currentImage;
		[mPastLife calculateUniqueNumber];
		[self loadResultViewController:mPastLife];
	}
}

-(void)loadResultViewController:(PastLife*)inPastLife
{
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {   // iPhone 3GS, 4, and 4S and iPod Touch 3rd and 4th generation: 3.5 inch screen (diagonally measured)
            
            if(!mResultController){
				// Instantiate the initial view controller object from the storyboard
				self.mResultController = [[ResultController alloc] initWithNibName:@"ResultController-iPhoneOld" bundle:[NSBundle mainBundle]];
            }
            // Instantiate a UIWindow object and initialize it with the screen size of the iOS device
        }
        
        if (iOSDeviceScreenSize.height == 568)
        {   // iPhone 5 and iPod Touch 5th generation: 4 inch screen (diagonally measured)
            if(!mResultController){
                // Instantiate the initial view controller object from the storyboard
                self.mResultController = [[ResultController alloc] initWithNibName:@"ResultController" bundle:[NSBundle mainBundle]];
            }
			
			
        }
        
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
        
    {   // The iOS device = iPad
        
        if(!mResultController){
            // Instantiate the initial view controller object from the storyboard
            self.mResultController = [[ResultController alloc] initWithNibName:@"ResultControlleriPad" bundle:[NSBundle mainBundle]];
        }
    }
	
    [self presentViewController:self.mResultController animated:YES completion:^(){
		//put your code here
        self.mResultController.pastLife=inPastLife;
        [self.mResultController find];
    }];
	
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return NO;
	
    return [super canPerformAction:action withSender:sender];
}


-(IBAction)clear:(id)sender
{
    firstNameTxt.text = @"";
    lastNameTxt.text = @"";
    dobTextField.text = @"";
    mUIImageView.image = nil;
}

@end
