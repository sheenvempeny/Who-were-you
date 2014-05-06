//
//  Utilities.m
//  Who were you
//
//  Created by Pradip on 5/5/14.
//  Copyright (c) 2014 Sheen Vempeny. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "UIImage+Resize.h"

@implementation Utilities


+ (void)applyShinyBackgroundWithColor:(UIColor *)color forView:(UIView*)newView
{
    
    // create a CAGradientLayer to draw the gradient on
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    // get the RGB components of the color
    const CGFloat *cs = CGColorGetComponents(color.CGColor);
    
    // create the colors for our gradient based on the color passed in
    layer.colors = [NSArray arrayWithObjects:
                    (id)[color CGColor],
                    (id)[[UIColor colorWithRed:0.98f*cs[0]
                                         green:0.98f*cs[1]
                                          blue:0.98f*cs[2]
                                         alpha:0.5] CGColor],
                    (id)[[UIColor colorWithRed:0.95f*cs[0]
                                         green:0.95f*cs[1]
                                          blue:0.95f*cs[2]
                                         alpha:0.6] CGColor],
                    (id)[[UIColor colorWithRed:0.93f*cs[0]
                                         green:0.93f*cs[1]
                                          blue:0.93f*cs[2]
                                         alpha:0.7] CGColor],
                    nil];
    
    // create the color stops for our gradient
    layer.locations = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:0.0f],
                       [NSNumber numberWithFloat:0.49f],
                       [NSNumber numberWithFloat:0.51f],
                       [NSNumber numberWithFloat:1.0f],
                       nil];
    
    layer.frame = newView.bounds;
    [newView.layer insertSublayer:layer atIndex:0];
}

+(NSArray*)animalNames
{
	NSArray *nameArray = [NSArray arrayWithObjects:@"Bee",@"Bear",@"Cat",@"Cow",@"Deer",@"Dog",
						  @"Duck",@"Elephant",@"Penguin",@"Frog",@"Giraffe",@"Hippopotamus",
						  @"Horse",@"Lion",@"Monkey",@"Parrot",@"Rabbit",@"Rooster",@"Sheep",@"Tiger",nil];
	return nameArray;
}


+(NSArray*)animalImages
{
	//Creating images
	NSMutableArray *imageArray = [NSMutableArray array];
	for (NSString *name in [Utilities animalNames]) 
	{
		[imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",name]]];
	}
	
	return imageArray;
	
}

+(UIImage*)createFinalImage:(PastLife*)pastLife
{
    CGSize _size = CGSizeMake(1000.0, 500.0);
    // create screen dump of the view of this view controller
    UIGraphicsBeginImageContext(_size);
	
    if(UIGraphicsBeginImageContextWithOptions != NULL)
    {
		UIGraphicsBeginImageContextWithOptions(_size, NO, 0.0);
    } else 
	{
        UIGraphicsBeginImageContext(_size);
    }
	
    CGRect firstRect = CGRectMake(5.0, 50.0, 490.0, 430.0);
    CGRect secondRect = CGRectMake(505.0, 50.0, 490.0, 430.0);
    //Drawing pastlife image
    UIImage *pastImage = [pastLife.pastLifeImage resizedImageToFitInSize:firstRect.size scaleIfSmaller:YES];
    [pastImage drawInRect:firstRect];
	//drawing current life image
	UIImage *currentImage = [pastLife.currentImage resizedImageToFitInSize:secondRect.size scaleIfSmaller:YES];
    [currentImage drawInRect:secondRect];
    //Drawing description
	CGRect firstLetterRect = CGRectMake(5.0, 5.0, 490.0, 40.0);
	NSString *pastLifeName = [[Utilities animalNames] objectAtIndex:pastLife.uniqueNumber];
    [[NSString stringWithFormat:@"%@ %@",@"You were a",pastLifeName] drawInRect:firstLetterRect withFont:[UIFont boldSystemFontOfSize:20.0] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	
    CGRect secondLetterRect = CGRectMake(505.0, 5.0, 490.0, 40.0);
    [[NSString stringWithFormat:@"%@ %@",pastLife.firstName,pastLife.lastName]  drawInRect:secondLetterRect withFont:[UIFont boldSystemFontOfSize:20.0] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    //drawing tail string
    CGRect tailRect = CGRectMake(5.0,480.0 , 950.0, 20.0);
    [@"Created By Who Were you. More apps visit www.iphoneapp4fun.com" drawInRect:tailRect withFont:[UIFont boldSystemFontOfSize:15.0] lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentCenter];
	UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return screenShot;
}



@end
