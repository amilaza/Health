//
//  ServiceHelper.h
//  DryCleaningApp
//
//  Created by Chandrakant Goyal on 3/02/15.
//  Copyright (c) 2015 Chandrakant Goyal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "Header.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface HTTPClient : AFHTTPClient

+ (HTTPClient *) sharedClient;

@end

@interface JSONRequestOperationQueue :AFJSONRequestOperation

@property (nonatomic, assign) NSInteger requestTag;

@end


typedef enum WebMethodCall {
    
    //0
    WebMethodType_Authentication,
    WebMethodType_Reminder,
    WebMethodType_BuildingList,
    WebMethodType_EnergyDevicesOfBuilding,
    WebMethodType_EnergyCircuits,
    WebMethodType_EnergyRealTimeCircuits,
    WebMethodType_LiveEnergy,
    WebMethodType_CircuitUpdate,
    WebMethodType_Alerts,
    WebMethodType_CircuitPowerToggle,
    WebMethodType_performanceIndex,
    WebMethodType_Budget, 
    WebMethodType_consumption
} WebMethodType;

@protocol ServiceHelperDelegate <NSObject>

@optional

-(void)serviceResponse:(id)response andMethodName:(WebMethodType)methodName;
-(void)serviceError:(id)response andMethodName:(WebMethodType)methodName;

@end

@interface ServiceHelper : NSObject

@property (nonatomic, assign) BOOL isReachable;

@property (nonatomic, assign) id<ServiceHelperDelegate> serviceHelperDelegate;

//+ (ServiceHelper *)sharedEngine;

-(void)callGetMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName    forPath:(NSString*)path andController: (UIViewController *)controller headerValue:(NSString*)header authenticationValue:(NSString*)authValue;

-(void)callPOSTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName andController:(UIViewController *)controller headerValue:(NSString*)header;


-(NSURLRequest*)getMultipart:(NSMutableDictionary*)dict andFileData:(NSDictionary*)fileData andHTTPMethod:(NSString*)httpMethod andPath:(NSString*)path andMethodName:(WebMethodType)methodName;

-(void)callPUTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName andController: (UIViewController *)controller withPath:(NSString*)path;

- (void)cancelRequestwithName:(WebMethodType)methodName;

@end
