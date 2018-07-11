//
//  MyDeviceInfo.m
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/15/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "MyDeviceInfo.h"

@implementation MyDeviceInfo

+(NSMutableArray*)parseDataForDevices:(NSArray*)arr{
    NSMutableArray *myDevice = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in arr){
        MyDeviceInfo *info = [[MyDeviceInfo alloc] init];
        info.strCircuitID = [dict objectForKey:@"circuitID"];
        info.strValue = [dict objectForKey:@"value"];
        info.strUnit = [dict objectForKey:@"unit"];
        info.strName = [dict objectForKey:@"name"];
        info.strCircuitSubType = [dict objectForKey:@"circuitSubtype"];
        info.strCost = [dict objectForKey:@"cost"];
        info.isOnline = [[dict objectForKey:@"online"] boolValue];
        info.strDeviceMaxPower = [dict objectForKey:@"maxPower"];
        info.strDeviceMaxPowerTime = [dict objectForKey:@"maxPowerTime"];
        info.strSensorType = [dict objectForKey:@"sensorType"];
        info.strSensorStatus = [dict objectForKey:@"sensorStatus"];
        info.strSensorUtility = [dict objectForKey:@"sensorUtility"];
        info.strMonthlyCost = [dict objectForKey:@"monthlyCost"];
        info.circuitPowerStatus = YES;
  
        [myDevice addObject:info];
    }
    return myDevice;
    
}
+(NSMutableArray *)parseAlertList: (NSArray *)response{
    
    NSMutableArray *arrayOfAlertList= [[NSMutableArray alloc]init];
    for (NSDictionary*List in response) {
        MyDeviceInfo *appUserInfo = [[MyDeviceInfo alloc]init];
        appUserInfo.strCircuitPowerStatus =[List objectForKey:@"status" expectedType:String];
        appUserInfo.strCircuitID = [List objectForKey:@"circuitID" expectedType:String];
        appUserInfo.strId = [List objectForKey:@"id" expectedType:String];
        appUserInfo.strCreateAt= [List objectForKey:@"created_at" expectedType:String];
        appUserInfo.strModifiedAt= [List objectForKey:@"modified_at" expectedType:String];
        appUserInfo.strCircuitName= [List objectForKey:@"circuitName" expectedType:String];
        appUserInfo.strDescription= [List objectForKey:@"description" expectedType:String];
        appUserInfo.strPriority= [List objectForKey:@"priority" expectedType:String];
        appUserInfo.strName = [List objectForKey:@"name" expectedType:String];
        [arrayOfAlertList addObject:appUserInfo];
    }
    return arrayOfAlertList;
}


/**********************Parse Data for Performance ***********************/

+(NSMutableArray*)parseDAtaForPerformance:(NSArray*)arr{
    NSMutableArray *myDevice = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in arr){
        MyDeviceInfo *info = [[MyDeviceInfo alloc] init];
        info.strLongEnergy = [dict valueForKey:@"longEnergy"];
        info.strLongReactiveEnergy = [dict objectForKey:@"longReactiveEnergy"];
        info.strVoltageMin = [dict objectForKey:@"voltageMin"];
        info.strVoltageMax = [dict objectForKey:@"voltageMax"];
        info.strCurrentMin = [dict objectForKey:@"currentMin"];
        info.strCurretMax = [dict objectForKey:@"currentMax"];
        info.strMaxDemand = [dict objectForKey:@"maxDemand"];
        info.strMaxDemandPF = [dict objectForKey:@"maxDemandPF"];
        info.strMaxPower = [dict objectForKey:@"maxPower"];
        info.strCost = [dict objectForKey:@"cost"];
        info.strCo2 = [dict objectForKey:@"co2"];
        info.strEnergy = [dict objectForKey:@"energy"];
        info.strReactiveEnergy = [dict objectForKey:@"reactiveEnergy"];
        info.strRealPower = [dict objectForKey:@"realPower"];
        info.strReactivePower = [dict objectForKey:@"reactivePower"];
        info.strApparentPower = [dict objectForKey:@"apparentPower"];
        info.strPowerFactor = [dict objectForKey:@"powerFactor"];
        info.strTime = [dict objectForKey:@"time"];
        info.strPrice = [dict objectForKey:@"price"];
        info.strTariffType = [dict objectForKey:@"tariffType"];
        
        [myDevice addObject:info];
    }
    return myDevice;
    
}


@end
