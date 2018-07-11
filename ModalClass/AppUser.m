//
//  AppUser.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "AppUser.h"
#import "NSDictionary+Extended.h"
#import "Header.h"
@implementation AppUser

+(AppUser*)sharedUser {

    static AppUser*sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(void)setupAttributesWith:(NSDictionary*)data {

    self.term = [data objectForKey:@"term" expectedType:String];
    self.logo = [data objectForKey:@"logo" expectedType:String];
    self.expired = [data objectForKey:@"expired" expectedType:String];
    self.email = [data objectForKey:@"email" expectedType:String];
    self.token = [data objectForKey:@"token" expectedType:String];
    self.role = [data objectForKey:@"role" expectedType:String];
    self.preference = [[UserPreference alloc] initForUser:self.email];
}

-(void)userLoggedOut {
    
    self.term = nil;
    self.logo = nil;
    self.expired = nil;
    self.email = nil;
    self.token = nil;
    self.role = nil;
    
    self.preference = nil;
    self.building = nil;
    self.device = nil;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:SELECTED_BUILDING_ID];
}

@end
