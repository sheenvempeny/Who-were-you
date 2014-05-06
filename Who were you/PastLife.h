//
//  PastLife.h
//  Who were you
//
//  Created by Sheen Vempeny on 11/3/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PastLife : NSObject //Modal stores the personal information
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
@property(nonatomic,assign) UIImage *currentImage;
@property(nonatomic,assign) UIImage *pastLifeImage;

-(void)calculateUniqueNumber; //Finding the unique number

@end
