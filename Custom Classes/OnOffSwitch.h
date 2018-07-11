//
//  OnOffSwitch.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/17/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OnOffSwitchDelegate <NSObject>
- (void)onOffSwitchDelegateSwitchOn;
- (void)onOffSwitchDelegateSwitchOff;
@end

@interface OnOffSwitch : UIView

@property (weak, nonatomic)id<OnOffSwitchDelegate> delegate;

@property (strong, nonatomic) UISwitch *customSwitch;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *leftLabel;

- (void)setSwicthOnorOff:(BOOL)status;
@end
