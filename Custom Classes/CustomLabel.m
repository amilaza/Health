//
//  CustomLabel.m
//  ElectricityVersion2
//
//  Created by Abhishek on 08/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "CustomLabel.h"
#import "Header.h"

@implementation CustomLabel


- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 10, 0, 0};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
