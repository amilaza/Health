//
//  UserPreference.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPreference : NSObject

@property (nonatomic, strong) NSString *numberOfPeople;
@property (nonatomic, strong) NSString *houseSize;
@property (nonatomic, strong) NSString *postCode;
@property (nonatomic, strong) NSString *monthlyBudget_kwh;
@property (nonatomic, strong) NSString *monthlyBudget_pound;
@property (nonatomic, strong) NSString *solarSize;
@property (nonatomic, assign) BOOL pushEnabled;

-(instancetype)initForUser:(NSString*)userEmail;

-(void)savePreferenceForUser:(NSString*)userEmail;

@end
