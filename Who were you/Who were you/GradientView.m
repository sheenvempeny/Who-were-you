//
//  GradientView.m
//  Color By Number
//
//  Created by Sheen Vempeny on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 160.0/255.0, 206.0/255.0, 76.0/255.0, 0.80,  // Start color
		121.0/255.0, 186.0/255.0, 1.0/255.0, 0.750 }; // End color
	
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
	
    CGRect currentBounds = self.bounds;
    CGPoint topCenter = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
    CGPoint midCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds));
    
	CGPoint bottomCenter = CGPointMake(CGRectGetMidX(currentBounds), CGRectGetMaxY(currentBounds));

		
	CGContextDrawLinearGradient(currentContext, glossGradient, topCenter, midCenter, 0);
	CGFloat components2[8] = { 121.0/255.0, 186.0/255.0, 1.0/255.0, 0.750, 160.0/255.0, 206.0/255.0, 76.0/255.0, 0.80 };
	CGGradientRelease(glossGradient);
	glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components2, locations, num_locations);
	CGContextDrawLinearGradient(currentContext, glossGradient, midCenter, bottomCenter, 0);

    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace); 
}

@end
