//
//  MenuViewController.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/24/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController
{
    __unsafe_unretained id delegate;
    BOOL disableFaceBook;
    IBOutlet UIButton *faceBookButton;
}

@property(nonatomic,assign) id delegate;

-(IBAction)saveToPhotoAlbum:(id)sender;
-(IBAction)shareToFacebook:(id)sender;
-(IBAction)cancel:(id)sender;



@end

@protocol  MenuViewDelegate <NSObject>

-(void)saveToPhotoAlbumClicked;
-(void)shareToFacebookClicked;
-(void)cancelClicked;

@end

