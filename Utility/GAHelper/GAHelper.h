//
//  GAHelper.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 06/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppUser.h"

typedef NS_ENUM(NSInteger, LogType) {
    
    LogType_Login,
    LogType_Reminder,
    LogType_DeviceListScreen,
    LogType_DeviceListScreen_DevicePowerOn,
    LogType_DeviceListScreen_DevicePowerOff,
    LogType_RightNowScreen,
    LogType_RightNowScreen_DevicePowerOn,
    LogType_RightNowScreen_DevicePowerOff,
    LogType_MotionDetectorScreen,
    LogType_PerformanceScreen,
    LogType_AlertScreen,
    LogType_BudgetScreen,
    LogType_PreferenceScreen,
    LogType_Logout
};

@interface GAHelper : NSObject

// returns an static instance of helper class
+(GAHelper*)instance;

// eneble / disable event logging to GA (Google Analytics)
-(void)enableLog:(BOOL)enable;

// send events of defined 'LogType' for 'AppUser'
-(void)sendEventOfType:(LogType)type
               forUser:(AppUser*)user;

@end
