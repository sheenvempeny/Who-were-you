//
//  PastLife.m
//  Who were you
//
//  Created by Sheen Vempeny on 11/3/12.
//  Copyright (c) 2012 Sheen Vempeny. All rights reserved.
//

#import "PastLife.h"
#include <CoreFoundation/CoreFoundation.h>
#include <unistd.h> 

@implementation PastLife

@synthesize firstName;
@synthesize lastName;
@synthesize dob;
@synthesize currentImage;
@synthesize pastLifeImage;
@synthesize uniqueNumber;


-(void)calculateUniqueNumber
{
    NSInteger totoalSum = 0;
    int cnt=0;
  
    //Caluclating dob value
    for (cnt = 0; cnt < dob.length; cnt++) 
	{
        NSString *currentStr = [dob substringWithRange:NSMakeRange(cnt, 1)];
        if ([currentStr isEqualToString:@"-"]) 
            continue;
        totoalSum += [currentStr integerValue];
    }
    
    const char* firstNameString = [firstName cStringUsingEncoding:NSASCIIStringEncoding];
    
    //converting first name value
      for (cnt = 0; cnt < firstName.length; cnt++)
	  {
          totoalSum += (NSInteger)firstNameString[cnt];
      }
    
    totoalSum *= firstName.length;
    
    const char* lastNameString = [firstName cStringUsingEncoding:NSASCIIStringEncoding];
    //converting last name value
    for (cnt = 0; cnt < lastName.length; cnt++)
	{
        totoalSum += (NSInteger)lastNameString[cnt];
    }
    
    totoalSum *= lastName.length;

    //Now we got a big number
    NSString *totalStr = [NSString stringWithFormat:@"%d",totoalSum];
    totoalSum = 0;
    while (totalStr.length > 2)
	{
        for (cnt=0; cnt < totalStr.length; cnt++) 
		{
            NSString *currentStr = [totalStr substringWithRange:NSMakeRange(cnt, 1)];
            totoalSum+=[currentStr integerValue];
        }
        totalStr = [NSString stringWithFormat:@"%d",totoalSum];
    }
     totoalSum = 0;
    if(totalStr.integerValue > 19)
	{
        for (cnt=0; cnt < totalStr.length; cnt++) 
		{
            NSString *currentStr = [totalStr substringWithRange:NSMakeRange(cnt, 1)];
            totoalSum += [currentStr integerValue];
        }
        totalStr = [NSString stringWithFormat:@"%d",totoalSum];
    }
    
    
    uniqueNumber = [totalStr integerValue];
    
}

@end
