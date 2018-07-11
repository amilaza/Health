//
//  UIColor+Extended.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 03/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extended)

+ (UIColor *)appRedColor;
+ (UIColor *)appBlueColor;
+ (UIColor *)appGreenColor;
+ (UIColor *)appYellowColor;
+ (UIColor *)appGrayColor;
+ (UIColor *)appPurpleColor;
+ (UIColor *)appOrangeColor;
+ (UIColor *)appGraphColor;


+ (UIColor *)colorWithHex:(NSInteger)hex;
+ (UIColor *)colorWithHex:(NSInteger)hex alpha:(CGFloat)alpha;

@end
