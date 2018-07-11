//
//  DeviceInfo.m
//  ElectricityVersion2
//aad498f514695ec0072237c366a64acc0610e20a
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "DeviceInfo.h"
#import "GWDateFormatter.h"
#import "NSDictionary+Extended.h"

@implementation DeviceInfo

-(instancetype)initWithAttributes:(NSDictionary*)data {
    
    self = [super init];
    
    [self updateAttributes:data];
    
    return self;
}

-(void)updateAttributes:(NSDictionary*)data {
    //new
    self.circuitID = [data objectForKey:@"circuitID" expectedType:String];
    self.circuitSubtype = [data objectForKey:@"circuitSubtype" expectedType:String];
    self.consumptionThreshold = [data objectForKey:@"consumptionThreshold" expectedType:String];
    self.cost = [data objectForKey:@"cost" expectedType:String];
    self.dailyCost = [data objectForKey:@"dailyCost" expectedType:String];
    self.hourlyCost = [data objectForKey:@"hourlyCost" expectedType:String];
    self.monthlyCost = [data objectForKey:@"monthlyCost" expectedType:String];
    self.monetaryThreshold = [data objectForKey:@"monetaryThreshold" expectedType:String];
    self.monthlyVariation = [data objectForKey:@"monthlyVariation" expectedType:String];
    self.name = [data objectForKey:@"name" expectedType:String];
    self.online = [data objectForKey:@"online" expectedType:String];
    self.sensorStatus = [data objectForKey:@"sensorStatus" expectedType:String];
    self.sensorType = [data objectForKey:@"sensorType" expectedType:String];
    self.sensorUtility = [data objectForKey:@"sensorUtility" expectedType:String];
    self.unit = [data objectForKey:@"unit" expectedType:String];
    self.value = [data objectForKey:@"value" expectedType:String];
    self.energy = [data objectForKey:@"energy" expectedType:String];
    self.battery = [data objectForKey:@"battery" expectedType:String];
    if([[data allKeys] containsObject:@"previousSensorStatus"]){
        self.previousSensorStatus = data[@"previousSensorStatus"];
        self.preTime = [self.previousSensorStatus[@"time"] doubleValue];
        self.preSensorStatus = self.previousSensorStatus[@"status"];
    }
    [self updateOtherCustomizedAttributes];
}

-(instancetype)initWithLiveEnergyAttributes:(NSDictionary*)data {

    self = [super init];
    
    [self updateForLiveEnergyAttribute:data];
    [self updateOtherCustomizedAttributes];
    
    return self;
}

-(void)updateForLiveEnergyAttribute: (NSDictionary*)data {
    
    
    
    //new
    self.gatewayId = [data objectForKey:@"gatewayId" expectedType:String];
    self.circuitType = [data objectForKey:@"circuitType" expectedType:String];
    self.buildingID = [data objectForKey:@"buildingID" expectedType:String];
    //old
    self.circuitID = [data objectForKey:@"circuitID" expectedType:String];
    self.name = [data objectForKey:@"circuitName" expectedType:String];
    self.circuitSubtype = [data objectForKey:@"circuitSubType" expectedType:String];
    self.current = [data objectForKey:@"current" expectedType:String];
    self.dailyCost = [data objectForKey:@"dailyCost" expectedType:String];
    self.maxThreshold = [data objectForKey:@"maxThreshold" expectedType:String];
    self.online = [data objectForKey:@"online" expectedType:String];
    self.realEnergy = [data objectForKey:@"realEnergy" expectedType:String];
    self.sensorStatus = [data objectForKey:@"sensorStatus" expectedType:String];
    self.sensorType = [data objectForKey:@"sensorType" expectedType:String];
    self.shortEnergy = [data objectForKey:@"shortEnergy" expectedType:String];
    self.time = [data objectForKey:@"time" expectedType:String];
    self.unit = [data objectForKey:@"unit" expectedType:String];
    
    self.sensorUtility = [data objectForKey:@"sensorUtility" expectedType:String];
    self.voltage = [data objectForKey:@"voltage" expectedType:String];
    self.battery = [data objectForKey:@"battery" expectedType:String];
    if([[data allKeys] containsObject:@"previousSensorStatus"]){
        self.previousSensorStatus = data[@"previousSensorStatus"];
        self.preTime = [self.previousSensorStatus[@"time"] doubleValue];
        self.preSensorStatus = self.previousSensorStatus[@"status"];
    }
}

-(void)updateOtherCustomizedAttributes {
    
    if ([self.sensorType caseInsensitiveCompare:@"PULSEREADER"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_PulseReader;
        self.deviceTag = 1000;
    }
    else if ([self.sensorType caseInsensitiveCompare:@"SMARTPLUG"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_SmartPlug;
        self.deviceTag = 80;
    }
    else if ([self.sensorType caseInsensitiveCompare:@"MOTIONDETECTOR"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_MotionDetector;
        self.deviceTag = 40;
    } else if ([self.sensorType caseInsensitiveCompare:@"WATTWATCHER"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_WattWatcher;
        self.deviceTag = 100;
    } else if ([self.sensorType caseInsensitiveCompare:@"WINDOWSENSOR"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_WindowSensor;
        self.deviceTag = 50;
    } else if ([self.sensorType caseInsensitiveCompare:@"KEYFOB"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_KeyFob;
        self.deviceTag = 60;
    } else if ([self.sensorType caseInsensitiveCompare:@"SMOKEDETECTOR"] == NSOrderedSame) {
        self.deviceSensorType = DeviceSensorType_SmokeDetector;
        self.deviceTag = 70;
    }
    
    
    if ([self.sensorUtility caseInsensitiveCompare:@"ELECTRICITY"] == NSOrderedSame) {
        self.deviceSensorUtility = DeviceSensorUtility_Electricity;
        if (self.deviceTag == 1000 || self.deviceTag == 100) {
            self.deviceTag = 110;
        }
    } else if ([self.sensorUtility caseInsensitiveCompare:@"GENERATION"] == NSOrderedSame) {
        self.deviceSensorUtility = DeviceSensorUtility_Generation;
        if (self.deviceTag == 100 || self.deviceTag == 1000) {
            self.deviceTag = 120;
        }
    } else if ([self.sensorUtility caseInsensitiveCompare:@"GAS"] == NSOrderedSame){
        self.deviceSensorUtility = DeviceSensorUtility_Gas;
        if (self.deviceTag == 100 || self.deviceTag == 1000) {
            self.deviceTag = 140;
        }
    } else if ([self.sensorUtility caseInsensitiveCompare:@"SOLAR"] == NSOrderedSame){
        self.deviceSensorUtility = DeviceSensorUtility_Solar;
        if (self.deviceTag == 100 || self.deviceTag == 1000) {
            self.deviceTag = 120;
        }
    }
    
    else { //if ([self.sensorUtility caseInsensitiveCompare:@"Custom item"] == NSOrderedSame) {
        self.deviceSensorUtility = DeviceSensorUtility_CustomItem;
    }
    
    self.UI_deviceName = (self.circuitSubtype.length > 0) ? [NSString stringWithFormat:@"%@ : %@",self.name,self.circuitSubtype] : self.name;
    self.UI_maxPowerTime = [[GWDateFormatter sharedManager] getTimeString:[self.maxPowerTime doubleValue]+[(GWDateFormatter*)[GWDateFormatter sharedManager] secondsFromGMT]];
}

@end
