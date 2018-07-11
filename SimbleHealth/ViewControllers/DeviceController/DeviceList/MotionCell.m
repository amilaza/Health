//
//  MotionCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/17/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "MotionCell.h"
#import "UIColor+Extended.h"
#import "AppUser.h"
#import "Header.h"
#import "DateCommon.h"

@implementation MotionCell{
    NSArray *baseColorArray;
    AppUser *loggedInUser;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    _viewLowBattery.hidden = YES;
    _lblLastStatus.hidden = YES;
}

- (void)setSensorStatus:(DeviceInfo *)deviceInfo {
    if (deviceInfo.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([deviceInfo.preSensorStatus boolValue] == YES){
            status = @"out of range";
        } else {
            status = @"in range";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Keyfob %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:deviceInfo.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
    if ([deviceInfo.battery boolValue] == YES) {
        _viewLowBattery.hidden = NO;
        _lblLastStatus.hidden = YES;
    } else {
        _viewLowBattery.hidden = YES;
    }
}
- (void)setDeviceInfoForWindowSensorWith:(DeviceInfo *)deviceInfo{
    if ([deviceInfo.sensorStatus isEqualToString:@"1"]) {
        _imvMotion.image = [UIImage imageNamed:@"ic_window_open"];
        _lblMotion.text = @"Window open";
        
    } else {
        _imvMotion.image = [UIImage imageNamed:@"ic_window_close"];
        _lblMotion.text = @"Window close";
    }
    _imageView_device.image = [UIImage imageNamed:@"ic_window"];
    if (deviceInfo.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([deviceInfo.preSensorStatus boolValue] == YES){
            status = @"opened";
        } else {
            status = @"closed";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Window %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:deviceInfo.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
}

- (void)setDeviceInforForMotionWith:(DeviceInfo *)deviceInfo{
    if ([deviceInfo.sensorStatus boolValue] == YES) {
        _imvMotion.image = [UIImage imageNamed:@"MotionDetector_on"];
        _lblMotion.text = @"Motion Detected";
        
    } else {
        _imvMotion.image = [UIImage imageNamed:@"MotionDetector_off"];
        _lblMotion.text = @"Motion Not Detected";
    }
    _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_motionDetector.png"];
    if (deviceInfo.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([deviceInfo.preSensorStatus boolValue] == YES){
            status = @"Detected";
        } else {
            status = @"Undetected";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Motion %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:deviceInfo.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
}
- (void)setDeviceInfo:(DeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    if (deviceInfo.online.boolValue == YES) {
        _lblTemperature.textColor = BLUE_TEXT_ONLINE;
        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
        if ([deviceInfo.value isEqualToString:@"NaN"]) {
            _lblTemperature.text = @"- ";
        } else {
            _lblTemperature.text = [NSString stringWithFormat:@"%@°C", deviceInfo.value];
        }
        if (deviceInfo.deviceSensorType == DeviceSensorType_WindowSensor) {
            [self setDeviceInfoForWindowSensorWith:deviceInfo];
        } else {
            [self setDeviceInforForMotionWith:deviceInfo];
        }
        [self setSensorStatus:deviceInfo];
    } else {
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
        _lblTemperature.textColor = DARK_LIGHT_TEXT_OFFLINE;
        _lblTemperature.text = [NSString stringWithFormat:@"-"];
        _lblMotion.text = @"-";
        if (deviceInfo.deviceSensorType == DeviceSensorType_WindowSensor) {
            _imvMotion.image = [UIImage imageNamed:@"ic_window_close"];
        } else {
            _imvMotion.image = [UIImage imageNamed:@"ic_motion_offline"];
        }

    }
    _label_DeviceName.text = deviceInfo.UI_deviceName;
    UIColor *baseColor = ((deviceInfo.online.boolValue == NO) ? [UIColor appGrayColor] : [baseColorArray objectAtIndex:(_indexPath.row%baseColorArray.count)]);
    _label_DeviceName.backgroundColor = baseColor;
    _imageView_device.backgroundColor = baseColor;
    _viewDeviceName.backgroundColor = baseColor;
    float totalCost = 0;
    for (DeviceInfo *device in self.array_deviceList) {
        totalCost += [device.cost floatValue];
    }
    double monthlyCostPercentage = 0;
    if ([loggedInUser.preference.monthlyBudget_kwh doubleValue] != 0) {
        monthlyCostPercentage = (([deviceInfo.energy doubleValue] * 100.0) / [loggedInUser.preference.monthlyBudget_kwh doubleValue]);
    }
    [self callApiForLiveEnergyData];
}

-(void)callApiForLiveEnergyData {
    NSString *getMethod = [NSString stringWithFormat:@"/api/live-energy/building/%@/tree?", loggedInUser.building.buildingID];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:getMethod
                                                      parameters:nil];
    NSString *auth = [NSString stringWithFormat:@"Bearer %@", loggedInUser.token];
    [request setValue:auth forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Print the response body in text
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        for (NSDictionary *dictCircuit in dict) {
            if ([dictCircuit[@"circuitID"] isEqualToString:_deviceInfo.circuitID]) {
                if ([dictCircuit[@"online"] boolValue ] == NO) {
                    return;
                }
                
                if ([dictCircuit[@"sensorType"] isEqualToString:@"WINDOWSENSOR"]) {
                    if ([dictCircuit[@"sensorStatus"] boolValue] == YES) {
                        _imvMotion.image = [UIImage imageNamed:@"ic_window_open"];
                        _lblMotion.text = @"Window open";
                        
                    } else {
                        _imvMotion.image = [UIImage imageNamed:@"ic_window_close"];
                        _lblMotion.text = @"Window close";
                    }
                    UIImage *deviceIcon = [UIImage imageNamed:@"ic_window"];
                    _imageView_device.image = deviceIcon;
                } else if ([dictCircuit[@"sensorType"] isEqualToString:@"MOTIONDETECTOR"]){
                    if ([dictCircuit[@"sensorStatus"] boolValue] == YES) {
                        _imvMotion.image = [UIImage imageNamed:@"MotionDetector_on"];
                        _lblMotion.text = @"Motion Detected";
                        
                    } else {
                        _imvMotion.image = [UIImage imageNamed:@"MotionDetector_off"];
                        _lblMotion.text = @"Motion Not Detected";
                    }
                    UIImage *deviceIcon = [UIImage imageNamed:@"EnergyDevice_motionDetector.png"];
                    _imageView_device.image = deviceIcon;
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}
@end
