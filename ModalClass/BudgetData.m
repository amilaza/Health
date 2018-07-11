//
//  BudgetData.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 10/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "BudgetData.h"
#import "NSDictionary+Extended.h"

@implementation EnergyItem

-(instancetype)initWithAttributes:(NSDictionary*)data {
    
    self = [super init];
    self.usage = [data objectForKey:@"usage" expectedType:String];
    self.name = [data objectForKey:@"name" expectedType:String];
    self.cost = [data objectForKey:@"cost" expectedType:String];
    
    return self;
}

@end

@implementation BudgetData

-(instancetype)initWithAttributes:(NSDictionary*)data {
    
    self = [super init];
    self.monetaryTrend = [data objectForKey:@"monetaryTrend" expectedType:String];
    self.monetaryThreshold = [data objectForKey:@"monetaryThreshold" expectedType:String];
    self.consumptionTrend = [data objectForKey:@"consumptionTrend" expectedType:String];
    self.consumptionThreshold = [data objectForKey:@"consumptionThreshold" expectedType:String];

    return self;
}

@end
