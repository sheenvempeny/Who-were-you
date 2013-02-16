//
//  AppDelegate.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/2/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    FBSession *session;
    
}

@property(nonatomic,retain)FBSession *session;
@property (strong, nonatomic) UIWindow *window;

@end
