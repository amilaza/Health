//
//  FlickerImageView.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 8/23/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "FlickerImageView.h"

@implementation FlickerImageView

- (void)drawRect:(CGRect)rect{

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:nil];
}

@end
