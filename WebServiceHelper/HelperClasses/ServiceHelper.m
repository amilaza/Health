//
//  ServiceHelper.m
//  DryCleaningApp
//
//  Created by Chandrakant Goyal on 3/02/15.
//  Copyright (c) 2015 Chandrakant Goyal. All rights reserved.
//

#import "ServiceHelper.h"
#import "Header.h"
//#warning - Disable Log for Release
#define LogEnable 0

//local URL
//#define SERVICE_BASE_URL @"http://172.16.0.9/PROJECTS/Qova/trunk/webservices/"
//#define SERVICE_BASE_URL @"http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/Qova/trunk/webservices/"



#pragma mark - HTTPClient class definition

static HTTPClient *_sharedClient;

@implementation HTTPClient

+ (HTTPClient *) sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[HTTPClient alloc] initWithBaseURL:[NSURL URLWithString:SERVICE_BASE_URL]];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
//        [_sharedClient setDefaultHeader:@"Accept" value:@"application/json"];
//        _sharedClient.parameterEncoding = AFJSONParameterEncoding;
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    });
    
    return _sharedClient;
}

-(id) initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    self.parameterEncoding = AFJSONParameterEncoding;
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    //    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
    
    if (!self) {
        return nil;
    }
    return self;
}

@end

#pragma mark - JSONRequestOperationQueue class definition

@implementation JSONRequestOperationQueue

@end

@interface ServiceHelper () <MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
}

@end

#pragma mark - ServiceHelper class definition
static ServiceHelper *_sharedHelper;

@implementation ServiceHelper

+ (ServiceHelper *)sharedEngine {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[ServiceHelper alloc] init];
    });
    
    return _sharedHelper;
}

#pragma mark - Class Methods
//private methods for Web-API call
-(void)callWebServiceWithRequest:(NSURLRequest*)request andMethodName:(WebMethodType)methodName andController: (UIViewController *)controller {
    
    if (controller != nil) {
        
        //add HUD to the passed view controller's view
        HUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
        [HUD setMode:MBProgressHUDModeIndeterminate];
        [HUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.3]];
        [HUD setMinShowTime:1.0];
        [HUD setColor:[UIColor clearColor]];
        [HUD setRemoveFromSuperViewOnHide:YES];
        [HUD setDelegate:self];
    }
    
    if (LogEnable) NSLog(@"REQUEST URL:%@", [request URL]);
    
    JSONRequestOperationQueue* operation =[JSONRequestOperationQueue JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
        
        if (LogEnable && JSON)
            NSLog(@"RESPONSE:\n%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);
        
        if (!self || !self.serviceHelperDelegate)
            return;
    
        if ([self.serviceHelperDelegate respondsToSelector:@selector(serviceResponse:andMethodName:)])
            [self.serviceHelperDelegate serviceResponse:JSON andMethodName:methodName];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        if (LogEnable) NSLog(@"error: %@",error);
        if (LogEnable && JSON)
            NSLog(@"RESPONSE:\n%@",[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]);

        [MBProgressHUD hideAllHUDsForView:controller.view animated:YES];
        
        if ([error code] == NSURLErrorCancelled) return;
        
        if (!self || !self.serviceHelperDelegate) return;
        
        if (!JSON) JSON = [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:kLocalizedError];
        if ([[JSON objectForKey:@"httpCode" expectedType:String] integerValue] == 403) {
            //unauthorized, Token expired
            [[APPDELEGATE navController] popToRootViewControllerAnimated:YES];
        }
        
        if ([self.serviceHelperDelegate respondsToSelector:@selector(serviceError:andMethodName:)])
            [self.serviceHelperDelegate serviceError:JSON andMethodName:methodName];
    }];
    
    [operation setRequestTag:methodName];
    [[[HTTPClient sharedClient] operationQueue] addOperation:operation];
}

#pragma mark - Request formation
/**
 ** Returns a POST multipart request from the passed parameter dictionary and file data
 **/

-(NSURLRequest*)getMultipartRequest:(NSDictionary*)dict withFileKey:(NSString *)fileKey path:(NSString*)path fileName:(NSString *)file andMIMEType:(NSString *)mime {
    
    NSURLRequest *request = nil;
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [requestDict removeObjectForKey:fileKey];
    
    NSData *data = [dict objectForKey:fileKey];
    
    request = [[HTTPClient sharedClient] multipartFormRequestWithMethod:@"POST" path:path parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:fileKey fileName:file mimeType:mime];
    }];
    
    return request;
}

/**
 ** Returns web method's corresponding context
 **/
-(NSString*)getActionName:(WebMethodType)methodName {
    
    NSString *actiondNameStr = @"";
    
    switch (methodName) {
            
        case WebMethodType_Authentication: actiondNameStr = @"api/auth"; break;
        case WebMethodType_Reminder: actiondNameStr = @"api/user/reminder"; break;
        case WebMethodType_BuildingList: actiondNameStr = @"api/buildings";break;
        case WebMethodType_EnergyDevicesOfBuilding: actiondNameStr = @"api/mobile/energy/buildings";break;
        case WebMethodType_EnergyCircuits: actiondNameStr = @"api/energy/circuits";break;
        case WebMethodType_LiveEnergy: actiondNameStr = @"api/live-energy/building";break;
        case WebMethodType_CircuitUpdate: actiondNameStr = @"api/circuits";break;
        case WebMethodType_Alerts: actiondNameStr = @"api/buildings";break;
        case WebMethodType_Budget: actiondNameStr = @"api/budgets"; break;

        case WebMethodType_CircuitPowerToggle: actiondNameStr = @"api/circuits"; break;
        case WebMethodType_performanceIndex: actiondNameStr = @"api/energy/circuits"; break;
        case WebMethodType_consumption: actiondNameStr = @"api/circuits"; break;
        case WebMethodType_EnergyRealTimeCircuits: actiondNameStr = @"api/live-energy/cp/circuits"; break;
        default: actiondNameStr = @""; break;
    }
    return actiondNameStr;
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
	// Remove HUD from screen when the HUD was hidded
	[HUD removeFromSuperview];
	 HUD = nil;
}

#pragma mark - Webservice Call Helper Methods

-(void)callGetMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName  forPath:(NSString*)path andController: (UIViewController *)controller  headerValue:(NSString*)header authenticationValue:(NSString*)authValue{
    NSMutableURLRequest *request;
    if([path length]){
        request = [[HTTPClient sharedClient] requestWithMethod:@"GET" path:[NSString stringWithFormat:@"%@/%@",[self getActionName:methodName],path] parameters:dict];
    }else{
        request = [[HTTPClient sharedClient] requestWithMethod:@"GET" path:[self getActionName:methodName] parameters:dict];
    }

    [request setValue:[NSString stringWithFormat:@"%@ %@",authValue,header] forHTTPHeaderField:@"Authorization"];
    [self callWebServiceWithRequest:request andMethodName:methodName andController:controller];
}

-(void)callPOSTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName andController: (UIViewController *)controller   headerValue:(NSString*)header  {
    
    NSMutableURLRequest *request;

    if (methodName == WebMethodType_CircuitUpdate) {
        
        request = [[HTTPClient sharedClient] requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@/%@",[self getActionName:methodName],[dict objectForKey:@"url"]] parameters:dict];
    }
    else if(methodName == WebMethodType_Budget){
          request =  [[HTTPClient sharedClient] requestWithMethod:@"POST" path:[NSString stringWithFormat:@"%@?token=%@",[self getActionName:methodName],header] parameters:dict];
    }
    else {
        
        request =  [[HTTPClient sharedClient] requestWithMethod:@"POST" path:[self getActionName:methodName] parameters:dict];
    }
    
    [self callWebServiceWithRequest:request andMethodName:methodName andController:controller];
}

-(void)callPUTMethodWithData:(NSMutableDictionary*)dict andMethodName:(WebMethodType)methodName andController: (UIViewController *)controller withPath:(NSString*)path {
    
       NSMutableURLRequest *request = [[HTTPClient sharedClient] requestWithMethod:@"PUT" path:[NSString stringWithFormat:@"%@/%@",[self getActionName:methodName],path] parameters:dict];
    [self callWebServiceWithRequest:request andMethodName:methodName andController:controller];
}


-(NSURLRequest*)getMultipart:(NSMutableDictionary*)dict andFileData:(NSDictionary*)fileData andHTTPMethod:(NSString*)httpMethod andPath:(NSString*)path andMethodName:(WebMethodType)methodName{
    NSURLRequest *request = nil;
    
    // seperating images and other parameters
    NSMutableDictionary *imageDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [imageDict setObject:(UIImage*)obj forKey:key];
            [requestDict removeObjectForKey:key];
        }
    }];
    
    request = [[HTTPClient sharedClient] multipartFormRequestWithMethod:httpMethod path:path parameters:requestDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [imageDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(obj, 0.5) name:key fileName:@"taxidriverapp.jpg" mimeType:@"image/jpeg"];
        }];
        
        __block NSError *error;
        [fileData enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([obj isKindOfClass:[NSURL class]]) {
                [formData appendPartWithFileURL:[fileData objectForKey:key] name:key error:&error];
            }
        }];
    }];
    
    return request;
}

- (void)cancelRequestwithName:(WebMethodType)methodName {
    
    NSArray *operationArray = [[[HTTPClient sharedClient] operationQueue] operations];
    
    for (JSONRequestOperationQueue *queueOperation in operationArray) {
        if (queueOperation.requestTag == methodName) {
            [queueOperation cancel];
        }
    }
}

@end
