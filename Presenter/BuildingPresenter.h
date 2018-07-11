//
//  BuildingPresenter.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "BasePresenter.h"
#import "IBuildingView.h"
#import "BuildingResponse.h"

@interface BuildingPresenter : BasePresenter
@property (nonatomic, weak) id<IBuildingView> delegate;

- (void )getListBuildingswithParam:(NSDictionary *)params;
@end
