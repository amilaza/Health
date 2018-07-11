//
//  PerformanceInfo.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 09/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceInfo : NSObject

@property (nonatomic, strong) NSString *currentMin;
@property (nonatomic, strong) NSString *currentMax;
@property (nonatomic, strong) NSString *co2;
@property (nonatomic, strong) NSString *realPower;
@property (nonatomic, strong) NSString *apparentPower;
@property (nonatomic, strong) NSString *reactiveEnergy;
@property (nonatomic, strong) NSString *maxDemandPF;
@property (nonatomic, strong) NSString *cost;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *reactivePower;
@property (nonatomic, strong) NSString *maxDemand;
@property (nonatomic, strong) NSString *longReactiveEnergy;
@property (nonatomic, strong) NSString *energy;
@property (nonatomic, strong) NSString *tariffType;
@property (nonatomic, strong) NSString *circuitID;
@property (nonatomic, strong) NSString *powerFactor;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *voltageMin;
@property (nonatomic, strong) NSString *voltageMax;
@property (nonatomic, strong) NSString *longEnergy;
@property (nonatomic, strong) NSString *maxPower;

-(instancetype)initWithAttributes:(NSDictionary*)data;

@end
