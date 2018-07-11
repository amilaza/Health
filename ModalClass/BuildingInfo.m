//
//  BuildingInfo.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "BuildingInfo.h"
#import "NSDictionary+Extended.h"

@implementation BuildingInfo

-(instancetype)initWithAttributes:(NSDictionary*)data {
    
    self = [super init];

    self.co2 = [data objectForKey:@"co2" expectedType:String];
    self.country = [data objectForKey:@"country" expectedType:String];
    self.occupants = [data objectForKey:@"occupants" expectedType:String];
    self.customerID = [data objectForKey:@"customerID" expectedType:String];
    self.streetNumber = [data objectForKey:@"streetNumber" expectedType:String];
    self.resellerID = [data objectForKey:@"resellerID" expectedType:String];
    self.streetName = [data objectForKey:@"streetName" expectedType:String];
    self.name = [data objectForKey:@"name" expectedType:String];
    self.city = [data objectForKey:@"city" expectedType:String];
    self.type = [data objectForKey:@"type" expectedType:String];
    self.state = [data objectForKey:@"state" expectedType:String];
    self.genTariff = [data objectForKey:@"genTariff" expectedType:String];
    self.buildingID = [data objectForKey:@"buildingID" expectedType:String];
    self.constructed = [data objectForKey:@"constructed" expectedType:String];
    self.timezone = [data objectForKey:@"timezone" expectedType:String];
    self.area = [data objectForKey:@"area" expectedType:String];
    self.weekStart = [data objectForKey:@"weekStart" expectedType:String];
    self.levels = [data objectForKey:@"levels" expectedType:String];
    self.conTariff = [data objectForKey:@"conTariff" expectedType:String];
    self.postcode = [data objectForKey:@"postcode" expectedType:String];
    
    return self;
}

@end
