//
//  SolarCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/16/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "SolarCell.h"
#import "UIColor+Extended.h"
#import "AppUser.h"
#import "UserPreference.h"

@implementation SolarCell{
    NSArray *baseColorArray;
    AppUser *loggedInUser;
    UserPreference *preference;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    preference = [[AppUser sharedUser] preference];
    // Initialization code
    
}

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    if (deviceInfo.online.boolValue == YES) {
        
        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
    } else {
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
    }
    _label_DeviceName.text = deviceInfo.UI_deviceName;
    
    UIImage *deviceIcon = [UIImage imageNamed:@"EnergyDevice_solar.png"];
    _imageView_device.image = deviceIcon;
    UIColor *baseColor = ((deviceInfo.online.boolValue == NO) ? [UIColor appGrayColor] : [baseColorArray objectAtIndex:(_indexPath.row%baseColorArray.count)]);
    _label_DeviceName.backgroundColor = baseColor;
    _imageView_device.backgroundColor = baseColor;
    _viewDeviceName.backgroundColor = baseColor;
    float enenery = [deviceInfo.value doubleValue];
    _lblEnergy.text = [NSString stringWithFormat:@"%.f %@", enenery, deviceInfo.unit];
    float percent = 0;
    if (preference.solarSize.length> 0) {
        percent = 100 * enenery / [preference.solarSize floatValue];
    } else {
        percent = 0;
    }
    _lblRightNow.text = [NSString stringWithFormat:@"RIGHT NOW: OUTPUT %0.1f%%", percent];
    if (percent > 100) {
        _lblOutput.frame = _viewOutput.bounds;
    } else {
        CGRect frame = _viewOutput.bounds;
        frame.size.width = percent *_viewOutput.frame.size.width /100;
        _lblOutput.frame = frame;
    }
}
@end
