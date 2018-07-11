//
//  KeyFobCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 7/3/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "KeyFobCell.h"
#import "UIColor+Extended.h"
#import "AppUser.h"
#import "Header.h"
@implementation KeyFobCell {
    NSArray *baseColorArray;
    AppUser *loggedInUser;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [super awakeFromNib];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    _viewDash.hidden = YES;
    _viewOnline.hidden = NO;
    _viewOutOfRange.hidden = NO;
}

- (void)setSensorStatus:(DeviceInfo *)deviceInfo {
    if (deviceInfo.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
    }
    if ([deviceInfo.battery boolValue] == YES) {
        _viewLowBattery.hidden = NO;
        _lblLastStatus.hidden = YES;
    } else {
        _viewLowBattery.hidden = YES;
    }
}

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo {
    
    _deviceInfo = deviceInfo;
    if (deviceInfo.online.boolValue == YES) {
        
        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imvConnectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
        [self setSensorStatus:deviceInfo];
        
        //online mean in range
        _imvKeyfob.image = [UIImage imageNamed:@"ic_in_range"];
        _lblKeyfob.text = @"In Range";
        _viewDash.hidden = YES;
        _viewOnline.hidden = NO;
        _viewOutOfRange.hidden = NO;
        
        
    } else {
        _imvConnectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
        
        // offline mean out of range
        _imvKeyfob.image = [UIImage imageNamed:@"ic_range"];
        _lblKeyfob.text = @"";
        _viewDash.hidden = NO;
        _viewOnline.hidden = YES;
        _viewOutOfRange.hidden = YES;
        
        
    }
    _imvDevice.image = [UIImage imageNamed:@"ic_keyfob"];
//    if ([deviceInfo.sensorStatus boolValue] == YES) {
//        _imvKeyfob.image = [UIImage imageNamed:@"ic_in_range"];
//        _lblKeyfob.text = @"In Range";
//        _viewDash.hidden = YES;
//        _viewOnline.hidden = NO;
//        _viewOutOfRange.hidden = NO;
//
//    } else {
//        _imvKeyfob.image = [UIImage imageNamed:@"ic_range"];
//        _lblKeyfob.text = @"";
//        _viewDash.hidden = NO;
//        _viewOnline.hidden = YES;
//        _viewOutOfRange.hidden = YES;
//    }
    _lblDeviceName.text = deviceInfo.UI_deviceName;
    
    
    UIColor *baseColor = ((deviceInfo.online.boolValue == NO) ? [UIColor appGrayColor] : [baseColorArray objectAtIndex:(_indexPath.row%baseColorArray.count)]);
    _lblDeviceName.backgroundColor = baseColor;
    _imvDevice.backgroundColor = baseColor;
    _viewDeviceName.backgroundColor = baseColor;
    
    float totalCost = 0;
    for (DeviceInfo *device in self.array_deviceList) {
        totalCost += [device.cost floatValue];
    }
    
    double monthlyCostPercentage = 0;
    if ([loggedInUser.preference.monthlyBudget_kwh doubleValue] != 0) {
        monthlyCostPercentage = (([deviceInfo.energy doubleValue] * 100.0) / [loggedInUser.preference.monthlyBudget_kwh doubleValue]);
    }
    _imvOutOfRange.backgroundColor = _viewDeviceName.backgroundColor;
}

-(void)animateImageView {
    
    _imvDevice.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
        _imvDevice.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [_imvDevice layoutIfNeeded];
    }];
    
    
}
@end
