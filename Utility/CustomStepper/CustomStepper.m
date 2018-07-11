//
//  CustomStepper.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/31/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "CustomStepper.h"

@implementation CustomStepper


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.minimumValue = 0;
    //self.maximumValue = 12;
    self.wraps = NO;
    self.autorepeat = NO;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1].CGColor;
}

@end
