//
//  AppUser.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 25/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPreference.h"
#import "BuildingInfo.h"
#import "DeviceInfo.h"
#import "BuildingResponse.h"
@interface AppUser : NSObject

+(AppUser*)sharedUser;

@property (nonatomic, strong) NSString *term;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *expired;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *role;

-(void)setupAttributesWith:(NSDictionary*)data;
-(void)userLoggedOut;

@property (nonatomic, strong) UserPreference *preference;
@property (nonatomic, strong) BuildingResponse *building;
@property (nonatomic, strong) DeviceInfo *device;

@end
