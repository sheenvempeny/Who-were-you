//
//  PastLife.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/3/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PastLife : NSObject
{
    
    NSString *firstName;
    NSString *lastName;
    NSString *dob;
    UIImage *currentImage;
    UIImage *pastLifeImage;
    NSInteger uniqueNumber;
}
@property(nonatomic,readonly) NSInteger uniqueNumber;
@property(nonatomic,retain) NSString *firstName;
@property(nonatomic,retain) NSString *lastName;
@property(nonatomic,retain) NSString *dob;
@property(nonatomic,retain) UIImage *currentImage;
@property(nonatomic,retain) UIImage *pastLifeImage;

-(void)calculateUniqueNumber;

@end
