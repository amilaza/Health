//
//  UserPreference.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "UserPreference.h"

@implementation UserPreference

-(instancetype)initForUser:(NSString*)userEmail {

    self = [super init];
    
    NSDictionary *userData = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"preferenece_%@",userEmail]];
    
    if (userData) {
        
        self.numberOfPeople = [userData objectForKey:@"numberOfPeople"];
        self.houseSize = [userData objectForKey:@"houseSize"];
        self.postCode = [userData objectForKey:@"postCode"];
        self.monthlyBudget_kwh = [userData objectForKey:@"monthlyBudget_kwh"];
        self.monthlyBudget_pound = [userData objectForKey:@"monthlyBudget_pound"];
        self.pushEnabled = [[userData objectForKey:@"pushEnabled"] boolValue];
        self.solarSize = [userData objectForKey:@"solarSize"];
    }
    else {
        
        self.numberOfPeople = @"2";
        self.houseSize = @"Medium";
        self.postCode = @"WR4 3NF";
        self.monthlyBudget_kwh = @"200";
        self.monthlyBudget_pound = @"50";
        self.solarSize = @"200";
        self.pushEnabled = YES;
        
        [self savePreferenceForUser:userEmail];
    }

    return self;
}

-(void)savePreferenceForUser:(NSString*)userEmail {
    
    NSMutableDictionary *userPreference = [NSMutableDictionary dictionary];
    [userPreference setObject:self.numberOfPeople forKey:@"numberOfPeople"];
    [userPreference setObject:self.houseSize forKey:@"houseSize"];
    [userPreference setObject:self.postCode forKey:@"postCode"];
    [userPreference setObject:self.monthlyBudget_kwh forKey:@"monthlyBudget_kwh"];
    [userPreference setObject:self.monthlyBudget_pound forKey:@"monthlyBudget_pound"];
    [userPreference setObject:[NSNumber numberWithBool:self.pushEnabled] forKey:@"pushEnabled"];
    [userPreference setObject:self.solarSize forKey:@"solarSize"];
    
    [[NSUserDefaults standardUserDefaults] setObject:userPreference forKey:[NSString stringWithFormat:@"preferenece_%@",userEmail]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
