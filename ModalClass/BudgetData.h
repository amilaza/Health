//
//  BudgetData.h
//  ElectricityVersion2
//
//  Created by Krishna Kant Kaira on 10/02/16.
//  Copyright © 2016 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnergyItem : NSObject

@property (strong, nonatomic) NSString *usage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *cost;

-(instancetype)initWithAttributes:(NSDictionary*)data;

@end


@interface BudgetData : NSObject

@property (strong, nonatomic) NSString *monetaryTrend;
@property (strong, nonatomic) NSString *monetaryThreshold;
@property (strong, nonatomic) NSString *consumptionTrend;
@property (strong, nonatomic) NSString *consumptionThreshold;

-(instancetype)initWithAttributes:(NSDictionary*)data;

@end
