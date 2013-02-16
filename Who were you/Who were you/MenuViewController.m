//
//  MenuViewController.m
//  Who were you
//
//  Created by Sheen Vempeny on 11/24/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

@synthesize delegate;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveToPhotoAlbum:(id)sender
{
    
    [delegate saveToPhotoAlbumClicked];
    
}

-(IBAction)shareToFacebook:(id)sender
{
    
    
    [delegate shareToFacebookClicked];
    
}

-(IBAction)cancel:(id)sender
{
    
    
   [delegate cancelClicked];
    
}


@end
