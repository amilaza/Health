//
//  UIColor+CT.m
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "UIColor+CT.h"

@implementation UIColor (CT)

+ (UIColor*) randomColor{
    
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

+(NSMutableArray*)getArrayOfRandomColors{
    
    NSMutableArray *arrColor = [[NSMutableArray alloc] init];
    
    [arrColor addObject:[UIColor colorWithRed:254.0/255.0f green:120.0/255.0f blue:30.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:255.0/255.0f green:55.0/255.0f blue:56.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:238.0/255.0f green:106.0/255.f blue:156.0/255.f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:159.0/255.0f green:89.0/255.0f blue:187.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:245.0/255.0f green:145.0/255.f blue:32./255.f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:138.0/255.0f green:196.0/255.0f blue:64.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:22.0/255.0f green:177.0/255.0f blue:128.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:38.0/255.0f green:167.0/255.0f blue:223.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:189.0/255.0f green:16.0/255.0f blue:224.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:19.0/255.0f green:118.0/255.0f blue:200.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:51.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:0.0/255.0f green:0./255.0f blue:153./255.f alpha:1.f   ]];
    [arrColor addObject:[UIColor colorWithRed:0.0/255.0f green:51.0/255.0f blue:153.0/255.0f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:255.0/255.0f green:102.0/255.0f blue:102.0/255.f alpha:1.0f   ]];
    [arrColor addObject:[UIColor colorWithRed:0.0/255.f green:153.0/255.0f blue:153.0/255.0f alpha:1.0f]];
    [arrColor addObject:[UIColor colorWithRed:29.0/255.0f green:18.0/255.f blue:200.0/255.f alpha:1.0f]];
    [arrColor addObject:[UIColor colorWithRed:255.0/255.f green:165.0/255.f blue:0.0/255.0f alpha:1.0f]];
    [arrColor addObject:[UIColor colorWithRed:58.0/255.f green:151.0/255.f blue:181.0/255.0f alpha:1.0f]];
    [arrColor addObject:[UIColor colorWithRed:86.0/255.f green:180.0/255.f blue:170.0/255.0f alpha:1.0f]];
    [arrColor addObject:[UIColor colorWithRed:0.0/255.f green:151.0/255.f blue:255.0/255.0f alpha:1.0f]];
    
     [arrColor addObject:[UIColor colorWithRed:153.0/255.f green:153.0/255.f blue:0.0/255.0f alpha:1.0f]];
     [arrColor addObject:[UIColor colorWithRed:58.0/255.f green:181.0/255.f blue:151.0/255.0f alpha:1.0f]];
     [arrColor addObject:[UIColor colorWithRed:224.0/255.f green:206.0/255.f blue:237.0/255.0f alpha:1.0f]];
     [arrColor addObject:[UIColor colorWithRed:0.0/255.f green:203.0/255.f blue:255.0/255.0f alpha:1.0f]];
     [arrColor addObject:[UIColor colorWithRed:246.0/255.f green:84.0/255.f blue:106.0/255.0f alpha:1.0f]];
     [arrColor addObject:[UIColor colorWithRed:255.0/255.f green:153.0/255.f blue:186.0/255.0f alpha:1.0f]];
    return arrColor;
}

+(UIColor*)getRandomColorFromSelectedColors:(NSInteger)index{
    
    NSMutableArray *arrColor = [self getArrayOfRandomColors];
    
   // int randNo = arc4random() % ([arrColor count] - 1);
    return [arrColor objectAtIndex:index];
}

+(UIColor*)getRandomColor{
    
        int r = arc4random() % 255;
        int g = arc4random() % 255;
        int b = arc4random() % 255;
        return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
  
}

+(UIColor *)lightGrayMenuTitleColor{
    return [UIColor colorWithRed:180./255.f green:180./255.f blue:180./255.f alpha:1.f];
}
+(UIColor *)appBlueColor{
    return [UIColor colorWithRed:0./255.f green:165./255.f blue:222./255.f alpha:1.f];
}

+(UIColor *)appNavBackgroundColor{
    return [UIColor colorWithRed:30./255.f green:159.0/255.f blue:223./255.f alpha:1.f];
}


@end
