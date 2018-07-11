//
//  BuildingInfo.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildingInfo : NSObject

@property (nonatomic, strong) NSString *co2;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *occupants;
@property (nonatomic, strong) NSString *customerID;
@property (nonatomic, strong) NSString *streetNumber;
@property (nonatomic, strong) NSString *resellerID;
@property (nonatomic, strong) NSString *streetName;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *genTariff;
@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, strong) NSString *constructed;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *weekStart;
@property (nonatomic, strong) NSString *levels;
@property (nonatomic, strong) NSString *conTariff;
@property (nonatomic, strong) NSString *postcode;

-(instancetype)initWithAttributes:(NSDictionary*)data;

@end
