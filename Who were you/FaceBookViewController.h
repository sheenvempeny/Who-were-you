//
//  FaceBookViewController.h
//  Who were you
//
//  Created by Sheen Vempeny on 12/1/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBUploadView.h"

@interface FaceBookViewController : UIViewController <FBUploadViewProtocol,FBLoginViewDelegate>
{
    
    __unsafe_unretained id delegate;
    IBOutlet FBUploadView *uploadView;
    IBOutlet FBUploadView *cancelView;
    UIImage *imageToUpload;
    
}

@property(nonatomic,retain)UIImage *imageToUpload;
@property(nonatomic,assign) id delegate;



@end

@protocol FacebookViewDelegate <NSObject>

-(void)removeFacebookView;

@end