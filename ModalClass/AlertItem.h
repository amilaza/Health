//
//  AlertItem.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 28/01/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertItem : NSObject

@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *circuitID;
@property (nonatomic, strong) NSString *alertId;
@property (nonatomic, strong) NSString *created_at;
@property (nonatomic, strong) NSString *buildingID;
@property (nonatomic, strong) NSString *modified_at;
@property (nonatomic, strong) NSString *circuitName;
@property (nonatomic, strong) NSString *alertDescription;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *priority;

@property (nonatomic, strong) NSString *UI_agoTime;

-(instancetype)initWithAttributes:(NSDictionary*)data;

@end
