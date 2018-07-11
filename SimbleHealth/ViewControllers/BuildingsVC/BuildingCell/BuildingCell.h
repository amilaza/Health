//
//  BuildingCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingResponse.h"

@interface BuildingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imvBuilding;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) BuildingResponse *buildingObj;

@end
