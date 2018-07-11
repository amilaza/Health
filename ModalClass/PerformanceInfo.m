//
//  PerformanceInfo.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 09/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "PerformanceInfo.h"
#import "NSDictionary+Extended.h"

@implementation PerformanceInfo

-(instancetype)initWithAttributes:(NSDictionary*)data {

    self = [super init];
    self.longEnergy = [data objectForKey:@"longEnergy" expectedType:String];
    self.longReactiveEnergy = [data objectForKey:@"longReactiveEnergy" expectedType:String];
    self.voltageMin = [data objectForKey:@"voltageMin" expectedType:String];
    self.voltageMax = [data objectForKey:@"voltageMax" expectedType:String];
    self.currentMin = [data objectForKey:@"currentMin" expectedType:String];
    self.currentMax = [data objectForKey:@"currentMax" expectedType:String];
    self.maxDemand = [data objectForKey:@"maxDemand" expectedType:String];
    self.maxDemandPF = [data objectForKey:@"maxDemandPF" expectedType:String];
    self.maxPower = [data objectForKey:@"maxPower" expectedType:String];
    self.cost = [data objectForKey:@"cost" expectedType:String];
    self.price = [data objectForKey:@"price" expectedType:String];
    self.co2 = [data objectForKey:@"co2" expectedType:String];
    self.energy = [data objectForKey:@"energy" expectedType:String];
    self.reactiveEnergy = [data objectForKey:@"reactiveEnergy" expectedType:String];
    self.realPower = [data objectForKey:@"realPower" expectedType:String];
    self.reactivePower = [data objectForKey:@"reactivePower" expectedType:String];
    self.apparentPower = [data objectForKey:@"apparentPower" expectedType:String];
    self.powerFactor = [data objectForKey:@"powerFactor" expectedType:String];
    self.tariffType = [data objectForKey:@"tariffType" expectedType:String];
    self.circuitID = [data objectForKey:@"circuitID" expectedType:String];
    self.time = [data objectForKey:@"time" expectedType:String];
    return self;
}

@end
