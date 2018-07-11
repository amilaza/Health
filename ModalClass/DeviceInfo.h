//
//  DeviceInfo.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceSensorType) {
    
    DeviceSensorType_SmartPlug,
    DeviceSensorType_PulseReader,
    DeviceSensorType_MotionDetector,
    DeviceSensorType_WattWatcher,
    DeviceSensorType_WindowSensor,
    DeviceSensorType_KeyFob,
    DeviceSensorType_SmokeDetector
};

typedef NS_ENUM(NSInteger, DeviceSensorUtility) {
    
    DeviceSensorUtility_Electricity,
    DeviceSensorUtility_Generation,
    DeviceSensorUtility_CustomItem,
    DeviceSensorUtility_Gas,
    DeviceSensorUtility_Solar,
    
};


@interface DeviceInfo : NSObject

@property (nonatomic, strong) NSString *sensorStatus;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *maxPowerTime;
@property (nonatomic, strong) NSString *maxPower;
@property (nonatomic, strong) NSString *monthlyCost;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *sensorType;
@property (nonatomic, strong) NSString *circuitSubtype;
@property (nonatomic, strong) NSString *sensorUtility;
@property (nonatomic, strong) NSString *circuitID;
@property (nonatomic, strong) NSString *online;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cost;

@property (nonatomic, strong) NSString *UI_maxPowerTime;

@property (nonatomic, assign) DeviceSensorType deviceSensorType;
@property (nonatomic, assign) DeviceSensorUtility deviceSensorUtility;
@property (nonatomic, strong) NSString *UI_deviceName;

//new attributes on 'Right Now' section
@property (nonatomic, strong) NSString *current;
@property (nonatomic, strong) NSString *dailyCost;
@property (nonatomic, strong) NSString *maxThreshold;
@property (nonatomic, strong) NSString *realEnergy;
@property (nonatomic, strong) NSString *shortEnergy;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *voltage;

// new property
@property (nonatomic, strong) NSString *gatewayId;
@property (nonatomic, strong) NSString *circuitType;
@property (nonatomic, strong) NSString *sensor_id;
@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, strong) NSString *energy;
@property (nonatomic, strong) NSString *energyConsumptionPercentage;
@property (nonatomic, strong) NSString *consumptionThreshold;
@property (nonatomic, strong) NSString *hourlyCost;
@property (nonatomic, strong) NSString *monetaryThreshold;
@property (nonatomic, strong) NSString *monthlyVariation;
@property (nonatomic, strong) NSString *battery;
@property (nonatomic, strong) NSDictionary *previousSensorStatus;
@property (nonatomic, strong) NSString *preSensorStatus;
@property (nonatomic, assign) double preTime;
// order
@property (nonatomic, assign) NSInteger deviceTag;
//initialisation method for
-(instancetype)initWithAttributes:(NSDictionary*)data;
-(void)updateAttributes:(NSDictionary*)data;

//new initialisation method for 'Right Now' section
-(instancetype)initWithLiveEnergyAttributes:(NSDictionary*)data;
-(void)updateForLiveEnergyAttribute: (NSDictionary*)data;

@end
