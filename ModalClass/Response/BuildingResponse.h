//
//  BuildingResponse.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol BuildingResponse
@end


@interface BuildingResponse : JSONModel
@property(strong, nonatomic) NSString *area;
@property(strong, nonatomic) NSString *buildingID;
@property(strong, nonatomic) NSString *co2;
@property(strong, nonatomic) NSString *conTariff;
@property(strong, nonatomic) NSString *constructed;
@property(strong, nonatomic) NSString *country;
@property(strong, nonatomic) NSString *customerID;
@property(strong, nonatomic) NSString *genTariff;
@property(strong, nonatomic) NSString *levels;

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *occupants;
@property(strong, nonatomic) NSString *postcode;
@property(strong, nonatomic) NSString *resellerID;
@property(strong, nonatomic) NSString *state;
@property(strong, nonatomic) NSString *streetName;
@property(strong, nonatomic) NSString *streetNumber;
@property(strong, nonatomic) NSString *city;
@property(strong, nonatomic) NSString *timezone;
@property(strong, nonatomic) NSString *type;
@property(strong, nonatomic) NSString *weekStart;
@end
