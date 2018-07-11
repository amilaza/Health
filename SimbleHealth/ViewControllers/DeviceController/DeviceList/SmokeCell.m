
//
//  SmokeCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 7/19/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "SmokeCell.h"
#import "UIColor+Extended.h"
#import "AppUser.h"
#import "Header.h"
#import "ServiceHelper.h"

@implementation SmokeCell {
    NSArray *baseColorArray;
    AppUser *loggedInUser;
    ServiceHelper *appWebEngine;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [super awakeFromNib];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    _viewLowBattery.hidden = YES;
    _lblLastStatus.hidden = YES;
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
        _lblTemperature.textColor = BLUE_TEXT_ONLINE;
        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imvConnectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
        if ([deviceInfo.value isEqualToString:@"0"] || [deviceInfo.value isEqualToString:@"NaN"]) {
            _lblTemperature.text = [NSString stringWithFormat:@"-"];
        } else {
            _lblTemperature.text = [NSString stringWithFormat:@"%@°C", deviceInfo.value];
        }
        [self setSensorStatus:deviceInfo];
    } else {
        _imvConnectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
        _lblTemperature.textColor = DARK_LIGHT_TEXT_OFFLINE;
        _lblTemperature.text = [NSString stringWithFormat:@"-"];
    }
    _imvDevice.image = [UIImage imageNamed:@"ic_smokedetecter"];
    if ([deviceInfo.sensorStatus boolValue] == YES) {
        _imvSmoke.image = [UIImage imageNamed:@"ic_flame"];
        _lblSmoke.text = @"Fire";
        [self animateImageView];
        
    } else {
        _imvSmoke.image = [UIImage imageNamed:@"ic_shield"];
        _lblSmoke.text = @"Safe";
    }
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
    [self callApiForLiveEnergyData];
}

-(void)animateImageView {
    
    _imvDevice.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 delay:0.0 options:(UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction) animations:^{
        _imvDevice.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [_imvDevice layoutIfNeeded];
    }];
}


#pragma mark - Service Helper Methods
-(ServiceHelper *)getAppEngine {
    
    if (!appWebEngine) appWebEngine = [[ServiceHelper alloc] init];
//    [appWebEngine setServiceHelperDelegate:self];
    
    return appWebEngine;
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
                if ([dictCircuit[@"sensorStatus"] boolValue] == YES) {
                    _lblSmoke.text = @"Fire";
                    _imvSmoke.image = [UIImage imageNamed:@"ic_flame"];
                }
                else {
                    _lblSmoke.text = @"Safe";
                    _imvSmoke.image = [UIImage imageNamed:@"ic_shield"];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [operation start];
}

@end
