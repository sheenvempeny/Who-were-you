//
//  GradientView.h
//  Color By Number
//
//  Created by Sheen Vempeny on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    eGreen = 0,
    eBlackAlpha = 1
    
}eColor;


@interface GradientView : UIView
{
    NSInteger   color;
}

@property(assign)NSInteger   color;

@end
