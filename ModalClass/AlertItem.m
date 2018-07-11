//
//  AlertItem.m
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 28/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import "AlertItem.h"
#import "NSDictionary+Extended.h"
#import "ValidationFields.h"

@implementation AlertItem

-(instancetype)initWithAttributes:(NSDictionary*)data {
    
    self = [super init];
    
    self.status = [data objectForKey:@"status" expectedType:String];
    self.circuitID = [data objectForKey:@"circuitID" expectedType:String];
    self.alertId = [data objectForKey:@"id" expectedType:String];
    self.created_at = [data objectForKey:@"created_at" expectedType:String];
    self.buildingID = [data objectForKey:@"buildingID" expectedType:String];
    self.modified_at = [data objectForKey:@"modified_at" expectedType:String];
    self.circuitName = [data objectForKey:@"circuitName" expectedType:String];
    self.alertDescription = [data objectForKey:@"description" expectedType:String];
    self.name = [data objectForKey:@"name" expectedType:String];
    self.priority = [data objectForKey:@"priority" expectedType:String];
    self.UI_agoTime = [ValidationFields getTimeRemaining:self.created_at];
    
    return self;
}

@end
