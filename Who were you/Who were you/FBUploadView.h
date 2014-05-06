//
//  FBUploadView.h
//  Who were you
//
//  Created by Sheen Vempeny on 12/1/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBUploadView : UIView
{
    
    __unsafe_unretained id delegate;
    NSString *text;
    NSInteger tag;
    BOOL enabled;
}

@property(nonatomic,assign)  BOOL enabled;
@property(nonatomic,assign)  NSInteger tag;
@property(nonatomic,retain) NSString *text;
@property(nonatomic,assign) id delegate;
- (void)initialize;
@end


@protocol FBUploadViewProtocol <NSObject>

-(void)uploadPhoto;

-(void)cancelled;

@end