//
//  SmartPlugCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/22/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "SmartPlugCell.h"
#import "UIColor+Extended.h"
#import "AppUser.h"
#import "AFNetworking.h"
#import "ServiceHelper.h"
#import "Header.h"
#import <SevenSwitch/SevenSwitch-Swift.h>
#import "DateCommon.h"
@implementation SmartPlugCell{
    NSArray *baseColorArray;
    AppUser *loggedInUser;
    SevenSwitch *mySwitch;
}

-(void)dealloc {
    //remove the delegate on deallocation of the controller
}

- (void)awakeFromNib {
    [super awakeFromNib];
    baseColorArray = [NSArray arrayWithObjects:[UIColor appRedColor], [UIColor appBlueColor], [UIColor appGreenColor], [UIColor appYellowColor], [UIColor appPurpleColor], nil];
    loggedInUser = [AppUser sharedUser];
    mySwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake((_onOffSwicthView.frame.size.width - 80)/2, 2, 80, 30)];
    [mySwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    mySwitch.onLabel.text = @"On";
    mySwitch.onLabel.textColor = [UIColor colorWithRed:20.0/255.0 green:137.0/255.0 blue:152.0/255.0 alpha:1.0];
    mySwitch.offLabel.text = @"Off";
    mySwitch.offLabel.textColor = [UIColor whiteColor];
    mySwitch.thumbTintColor = [UIColor lightGrayColor];
    mySwitch.onThumbTintColor = [UIColor colorWithRed:20.0/255.0 green:137.0/255.0 blue:152.0/255.0 alpha:1.0];
    mySwitch.onTintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    mySwitch.tintColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    mySwitch.isRounded = NO;
    [_onOffSwicthView addSubview:mySwitch];
    _lblLastStatus.hidden = YES;
}

- (void)updateSwitchFrame {
    mySwitch.frame = CGRectMake((_onOffSwicthView.frame.size.width - 80)/2, 2, 80, 30);
}

- (void)switchChanged:(SevenSwitch *)sender {
    [self callAPITurnOnOffSmartPlug];
}
- (void)setSenserStatusWith:(DeviceInfo *)deviceInfo {
    if (deviceInfo.previousSensorStatus != nil) {
        _lblLastStatus.hidden = NO;
        NSString *status = @"";
        if ([deviceInfo.preSensorStatus boolValue] == YES){
            status = @"turn on";
        } else {
            status = @"turn off";
        }
        _lblLastStatus.text = [NSString stringWithFormat:@"Smart Plug %@ %@", status, [DateCommon getTimePeriodFromNowToTimeStamp:deviceInfo.preTime]];
    } else {
        _lblLastStatus.text = @"-";
    }
}

- (void)setDeviceInfo:(DeviceInfo *)deviceInfo {
    _deviceInfo = deviceInfo;
    _onOffSwicthView.hidden = NO;
    if([deviceInfo.circuitSubtype isEqualToString:@"lighting"]){
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_lighting.png"];
    }
    else if ([deviceInfo.circuitSubtype isEqualToString:@"Kitchen appliance"]){
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_refrigerator.png"];
    }
    else if ([deviceInfo.circuitSubtype isEqualToString:@"Ac heater"]){
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_cooling.png"];
    }
    else {
        _imageView_device.image = [UIImage imageNamed:@"EnergyDevice_custom.png"];
    }
    if (deviceInfo.online.boolValue == YES) {
        
        _lblOffline.textColor =  [UIColor colorWithRed:30.0/255.0 green:149.0/255.0 blue:162.0/255.0 alpha:1.0];
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_open.png"] ;
        _lblOffline.text = @"Online";
        _lblEnergy.text = [NSString stringWithFormat:@"%.1f %@",[deviceInfo.value floatValue], deviceInfo.unit];
        _lbLCost.text = [NSString stringWithFormat:@"$ %@/week", deviceInfo.dailyCost];
        [mySwitch setOn:[deviceInfo.sensorStatus boolValue]];
        _viewSwicth.hidden = NO;
        [self setSenserStatusWith:deviceInfo];
    } else {
        _imageView_connectionState.image = [UIImage imageNamed:@"Wifi_close.png"] ;
        _lblOffline.textColor = [UIColor colorWithRed:196.0/255.0 green:69.0/255.0 blue:40.0/255.0 alpha:1.0];
        _lblOffline.text = @"Offline";
        _lblEnergy.text = [NSString stringWithFormat:@"-"];
        _lbLCost.text = [NSString stringWithFormat:@"-"];
        [mySwitch setOn:NO];
        _viewSwicth.hidden = YES;
    }
    _label_DeviceName.text = deviceInfo.UI_deviceName;
    UIColor *baseColor = ((deviceInfo.online.boolValue == NO) ? [UIColor appGrayColor] : [baseColorArray objectAtIndex:(_indexPath.row%baseColorArray.count)]);
    _label_DeviceName.backgroundColor = baseColor;
    _imageView_device.backgroundColor = baseColor;
    _viewDeviceName.backgroundColor = baseColor;
    
    [self getEnergyDataFromBeginOfWeek];
}

- (void)getEnergyDataFromBeginOfWeek {
    double toTS = [DateCommon convertTimeStampFromDate:[NSDate date]];
    double fromTS = [DateCommon getTimeStampFromBeginOfWeekByDate:[NSDate date]];
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"token"] = loggedInUser.token;
    params[@"fromTS"] = [NSNumber numberWithDouble:fromTS];
    params[@"toTS"] = [NSNumber numberWithDouble:toTS];
    
   
    
    NSString *getMethod = [NSString stringWithFormat:@"/api/mobile/energy/buildings/%@/tree?", loggedInUser.building.buildingID];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:getMethod
                                                      parameters:params];
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
                _lblEnergy.text = [NSString stringWithFormat:@"%.1f %@",[dictCircuit[@"value"] floatValue], _deviceInfo.unit];;
                _lbLCost.text = [NSString stringWithFormat:@"$ %.2f/week", [dictCircuit[@"cost"] floatValue]];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [mySwitch setOn:[_deviceInfo.sensorStatus boolValue]];
    }];
    [operation start];
}

#pragma mark - Service Helper Methods
- (void)callAPITurnOnOffSmartPlug{
    
    NSString *getMethod = [NSString stringWithFormat:@"api/circuits/%@/toggle", _deviceInfo.circuitID];
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
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        _deviceInfo.sensorStatus = dict[@"status"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [mySwitch setOn:[_deviceInfo.sensorStatus boolValue]];
    }];
    [operation start];
}



@end
