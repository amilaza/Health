//
//  UIColor+CT.h
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "Header.h"

@interface UIColor (CT)

+ (UIColor*) randomColor;
+(UIColor*)getRandomColorFromSelectedColors:(NSInteger)index;
+(UIColor*)getRandomColor;
+(UIColor *)lightGrayMenuTitleColor;
+(UIColor *)appBlueColor;
+(UIColor *)appNavBackgroundColor;
+(NSMutableArray*)getArrayOfRandomColors;
@end
