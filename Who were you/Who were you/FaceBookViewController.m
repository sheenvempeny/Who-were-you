//
//  FaceBookViewController.m
//  Who were you
//
//  Created by Sheen Vempeny on 12/1/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "FaceBookViewController.h"

@interface FaceBookViewController ()

@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

@end

@implementation FaceBookViewController

@synthesize loggedInUser = _loggedInUser;
@synthesize delegate;
@synthesize imageToUpload;

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
    CGRect loginViewFrame;
   
     if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
         loginViewFrame=CGRectMake(269.0, 16.0, 231.0, 51.0);
    else
         loginViewFrame=CGRectMake(37.0, 16.0, 231.0, 51.0);
  
    FBLoginView *loginView = [[FBLoginView alloc] init];
    
    loginView.frame = loginViewFrame;
    loginView.delegate = self;
    
    [self.view addSubview:loginView];
    
    //[loginView sizeToFit];

    
    uploadView.tag = 1;
    cancelView.tag = 2;
    uploadView.text=@"Upload";
    cancelView.text=@"Cancel";
    uploadView.delegate=self;
    cancelView.delegate=self;
    [uploadView initialize];
    [cancelView initialize];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)uploadPhoto
{
    
    [self postPhotoClick:nil];
    
}

-(void)cancelled
{
    
    [delegate removeFacebookView];
    
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // first get the buttons set for login mode
    uploadView.enabled = YES;
   
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
//    // here we use helper properties of FBGraphUser to dot-through to first_name and
//    // id properties of the json response from the server; alternatively we could use
//    // NSDictionary methods such as objectForKey to get values from the my json object
//    self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
//    // setting the profileID property of the FBProfilePictureView instance
//    // causes the control to fetch and display the profile picture for the user
//    self.profilePic.profileID = user.id;
    self.loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    BOOL canShareAnyhow = [FBNativeDialogs canPresentShareDialogWithSession:nil];
//    self.buttonPostPhoto.enabled = canShareAnyhow;
//    self.buttonPostStatus.enabled = canShareAnyhow;
//    self.buttonPickFriends.enabled = NO;
//    self.buttonPickPlace.enabled = NO;
//    
//    self.profilePic.profileID = nil;
//    self.labelFirstName.text = nil;
    uploadView.enabled=canShareAnyhow;
    self.loggedInUser = nil;
}

#pragma mark -

// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                                   defaultAudience:FBSessionDefaultAudienceEveryone
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
    
}

// Post Photo button handler; will attempt to invoke the native
// share dialog and, if that's unavailable, will post directly
- (IBAction)postPhotoClick:(UIButton *)sender {
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    
    
    // if it is available to us, we will post using the native dialog
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                    initialText:@"Who were you"
                                                                          image:imageToUpload
                                                                            url:nil
                                                                        handler:nil];
    if (!displayedNativeDialog) {
        [self performPublishAction:^{
            
            [FBRequestConnection startForUploadPhoto:imageToUpload
                                   completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                       [self showAlert:@"Photo Post" result:result error:error];
                                       uploadView.enabled = YES;
                                   }];
            
            uploadView.enabled = NO;
        }];
        
    }
}

// UIAlertView helper for post buttons
- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertMsg = error.localizedDescription;
        alertTitle = @"Error";
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.\nPost ID: %@",
                    message, [resultDict valueForKey:@"id"]];
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [self cancelled];
}



@end
