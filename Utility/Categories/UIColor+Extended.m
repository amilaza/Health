//
//  UIColor+Extended.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 03/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "UIColor+Extended.h"

@implementation UIColor (Extended)

+ (UIColor *)appRedColor {
    return [self colorWithHex:0xc4410D];
}

+ (UIColor *)appBlueColor {
    return [self colorWithHex:0x1cb4F1];
}

+ (UIColor *)appGreenColor {
    return [self colorWithHex:0x1EB2C4];
}

+ (UIColor *)appYellowColor {
    return [self colorWithHex:0xFFCA37];
}

+ (UIColor *)appGrayColor {
    return [self colorWithHex:0x8B8B8B];
}

+ (UIColor *)appPurpleColor {
    return [self colorWithHex:0x9A70B6];
}

+ (UIColor *)appOrangeColor {
    return [self colorWithHex:0xFF9718];
}
+ (UIColor *)appGraphColor {
    return [self colorWithHex:0xFF0000FF];
}

+ (UIColor *)colorWithHex:(NSInteger)hex {
    return [self colorWithHex:hex alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha {
    
    CGFloat red   = (CGFloat)((0xff0000 & hex) >> 16) / 255.0;
    CGFloat green = (CGFloat)((0xff00   & hex) >> 8)  / 255.0;
    CGFloat blue  = (CGFloat)(0xff      & hex)        / 255.0;
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

@end
