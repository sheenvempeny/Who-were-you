//
//  Utilities.h
//  Who were you
//
//  Created by Pradip on 5/5/14.
//  Copyright (c) 2014 Sheen Vempeny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PastLife.h"

@interface Utilities : NSObject
//adding background to view
+ (void)applyShinyBackgroundWithColor:(UIColor *)color forView:(UIView*)newView;
//animal images
+(NSArray*)animalImages;
//animal names
+(NSArray*)animalNames;
//creating final image for display and post in FB
+(UIImage*)createFinalImage:(PastLife*)pastLife;
@end
