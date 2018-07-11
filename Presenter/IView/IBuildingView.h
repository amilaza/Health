//
//  IBuildingView.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BuildingResponse.h"
@protocol IBuildingView <NSObject>
- (void)getListBuildingsSuccess:(NSArray *)data;
- (void)getListBuildingsFail:(NSError *)error;
@end
