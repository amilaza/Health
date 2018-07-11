//
//  GAMyDeviceCell.m
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/7/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAMyDeviceCell.h"

@implementation GAMyDeviceCell {
    NSArray *baseColorArray;
    AppUser *loggedInUser;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView_device.clipsToBounds = YES;
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    _viewLowBattery.hidden = YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.contentView layoutSubviews];
    
    CGRect bounds = self.label_DeviceName.bounds;
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)].CGPath;
    self.label_DeviceName.layer.mask = maskLayer;
}

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    if (deviceInfo.online.boolValue == YES) {

        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
        double cost = [deviceInfo.cost doubleValue];
        _lblMoneyUnderbudget.text = [NSString stringWithFormat:@"$ %.02f/day",cost];
        _lblEnergy.text = [NSString stringWithFormat:@"%.1f %@", [deviceInfo.value floatValue], deviceInfo.unit];
        
        if ([deviceInfo.battery boolValue] == YES) {
            _viewLowBattery.hidden = NO;
            _viewLowBattery.hidden = YES;
        } else {
            _viewLowBattery.hidden = YES;
        }
    } else {
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
        _lblMoneyUnderbudget.text = [NSString stringWithFormat:@"-"];
        _lblEnergy.text = [NSString stringWithFormat:@"-"];
    }
    _label_DeviceName.text = deviceInfo.UI_deviceName;
    
    if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Gas) {
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_gas.png"];
    } else if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Electricity) {
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_electricity.png"];
    } else if (deviceInfo.deviceSensorUtility == DeviceSensorUtility_Generation) {
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_electricity.png"];
    } else {
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_custom.png"];
    }

    UIColor *baseColor = ((deviceInfo.online.boolValue == NO) ? [UIColor appGrayColor] : [baseColorArray objectAtIndex:(_indexPath.row%baseColorArray.count)]);
    _label_DeviceName.backgroundColor = baseColor;
    _imageView_device.backgroundColor = baseColor;
    _viewDeviceName.backgroundColor = baseColor;
    if (deviceInfo.consumptionThreshold.length >0) {
        double monthlyCostPercentage = 0;
        if ([loggedInUser.preference.monthlyBudget_pound doubleValue] != 0) {
            monthlyCostPercentage = (([deviceInfo.cost doubleValue] * 100.0) / [loggedInUser.preference.monthlyBudget_pound doubleValue]);
        }
        if (monthlyCostPercentage > 100) {
            _lblPersentBudget.text = [NSString stringWithFormat:@"%0.2f%% over budget", (monthlyCostPercentage - 100.0)];
        } else {
            _lblPersentBudget.text = [NSString stringWithFormat:@"%0.2f%% under budget", (100.0 - monthlyCostPercentage)];
        }
    } else {
        _lblPersentBudget.text = @"-";
    }
    
}
@end
