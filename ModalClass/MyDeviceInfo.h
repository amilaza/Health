//
//  MyDeviceInfo.h
//  ElectricityVersion2
//
//  Created by Mohit Kumar on 12/15/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "Header.h"

@interface MyDeviceInfo : NSObject


/********************** Parse Data For My Devices Screen *******************/
@property(strong,nonatomic)NSString *strCircuitID;
@property(strong,nonatomic)NSString *strValue;
@property(strong,nonatomic)NSString *strUnit;
@property(strong,nonatomic)NSString *strName;
@property(strong,nonatomic)NSString *strCircuitSubType;
@property(strong,nonatomic)NSString *strCost;
@property BOOL isOnline,circuitPowerStatus;
@property(strong,nonatomic)NSString *strSensorType;
@property(strong,nonatomic)NSString *strCircuitPowerStatus;

@property(strong,nonatomic)NSString *strSensorStatus;
@property(strong,nonatomic)NSString *strMonthlyCost;
@property(strong,nonatomic)NSString *strId;
@property(strong,nonatomic)NSString *strDeviceMaxPower;
@property(strong,nonatomic)NSString *strDeviceMaxPowerTime;
@property(strong,nonatomic)NSString *strCreateAt;
@property(strong,nonatomic)NSString *strModifiedAt;
@property(strong,nonatomic)NSString *strCircuitName;
@property(strong,nonatomic)NSString *strDescription;
@property(strong,nonatomic)NSString *strPriority;
@property(strong,nonatomic)NSString *strPostCode;
@property(strong,nonatomic)NSString *strBudgetID;
@property(strong,nonatomic)NSString *strBudgetInKwh;
@property(strong,nonatomic)NSString *strBudgetInPond;
@property(strong,nonatomic)NSString *strSensorUtility;
+(NSMutableArray*)parseDataForDevices:(NSArray*)arr;
+(NSMutableArray *)parseAlertList: (NSArray *)response;



/********************** Parse Data For Performance Screen *******************/

@property(strong,nonatomic)NSString *strLongEnergy;
@property(strong,nonatomic)NSString *strLongReactiveEnergy;
@property(strong,nonatomic)NSString *strVoltageMin;
@property(strong,nonatomic)NSString *strVoltageMax;
@property(strong,nonatomic)NSString *strCurrentMin;
@property(strong,nonatomic)NSString *strCurretMax;
@property(strong,nonatomic)NSString *strMaxDemand;
@property(strong,nonatomic)NSString *strMaxDemandPF;
@property(strong,nonatomic)NSString *strMaxPower;
@property(strong,nonatomic)NSString *strPerformanceCost;
@property(strong,nonatomic)NSString *strCo2;
@property(strong,nonatomic)NSString *strEnergy;
@property(strong,nonatomic)NSString *strReactiveEnergy;
@property(strong,nonatomic)NSString *strRealPower;
@property(strong,nonatomic)NSString *strReactivePower;
@property(strong,nonatomic)NSString *strApparentPower;
@property(strong,nonatomic)NSString *strPowerFactor;
@property(strong,nonatomic)NSString *strTime;
@property(strong,nonatomic)NSString *strPrice;
@property(strong,nonatomic)NSString *strTariffType;





+(NSMutableArray*)parseDAtaForPerformance:(NSArray*)arr;



@end
