//
//  OnOffSwitch.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/17/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "OnOffSwitch.h"

@implementation OnOffSwitch
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        _customSwitch = [[UISwitch alloc]initWithFrame:CGRectMake((self.frame.size.width - 51)/2, (self.frame.size.height - 31)/2, 51, 31)];
        _customSwitch.backgroundColor = [UIColor clearColor];
        _customSwitch.tintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
        _customSwitch.onTintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];

        [_customSwitch addTarget:self action:@selector(switchIsChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_customSwitch];
        
        _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(_customSwitch.frame.origin.x - 2, _customSwitch.frame.origin.y, 51, _customSwitch.frame.size.height)];
        _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(_customSwitch.frame.origin.x, _customSwitch.frame.origin.y, 51 - 2, _customSwitch.frame.size.height)];
        _leftLabel.textAlignment = NSTextAlignmentLeft;
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _leftLabel.text = @"  On";
        _leftLabel.font = [UIFont systemFontOfSize:11];
        _leftLabel.textColor = [UIColor whiteColor];
        [self addSubview:_leftLabel];
        
        _rightLabel.text = @"Off    ";
        _rightLabel.font = [UIFont systemFontOfSize:11];
        _rightLabel.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        [self addSubview:_rightLabel];
    }
    return self;
}

- (void)layoutSubviews {
    _customSwitch.frame = CGRectMake((self.frame.size.width - 51)/2, (self.frame.size.height - 31)/2, 51, 31);
    _leftLabel.frame = CGRectMake(_customSwitch.frame.origin.x - 2, _customSwitch.frame.origin.y, 51, _customSwitch.frame.size.height);
    _rightLabel.frame = CGRectMake(_customSwitch.frame.origin.x, _customSwitch.frame.origin.y, 51 - 2, _customSwitch.frame.size.height);
}
- (void) switchIsChanged:(UISwitch *)paramSender{
    NSLog(@"Sender is = %@", paramSender);
    if ([paramSender isOn]){
        _leftLabel.hidden = NO;
        _rightLabel.hidden = YES;
        [_customSwitch setThumbTintColor:[UIColor colorWithRed:20.0/255.0 green:137.0/255.0 blue:152.0/255.0 alpha:1.0]];
        if ([self.delegate respondsToSelector:@selector(onOffSwitchDelegateSwitchOn)]) {
            [self.delegate onOffSwitchDelegateSwitchOn];
        }
    } else {
        _leftLabel.hidden = YES;
        _rightLabel.hidden = NO;
        [_customSwitch setThumbTintColor:[UIColor lightGrayColor]];
        if ([self.delegate respondsToSelector:@selector(onOffSwitchDelegateSwitchOff)]) {
            [self.delegate onOffSwitchDelegateSwitchOff];
        }
    }
}

- (void)setSwicthOnorOff:(BOOL)status {
    [_customSwitch setOn:status animated:NO];
    if (status == YES){
        _leftLabel.hidden = NO;
        _rightLabel.hidden = YES;
        [_customSwitch setThumbTintColor:[UIColor colorWithRed:20.0/255.0 green:137.0/255.0 blue:152.0/255.0 alpha:1.0]];
 
    } else {;
        [_customSwitch setThumbTintColor:[UIColor lightGrayColor]];
        _leftLabel.hidden = YES;
        _rightLabel.hidden = NO;
    }
}

@end
