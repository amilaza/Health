//
//  BuildingCell.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "BuildingCell.h"
#import "Header.h"

@implementation BuildingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBuildingObj:(BuildingResponse *)buildingObj {
    _buildingObj = buildingObj;
    _lblName.text = buildingObj.name;
    _lblCity.text = buildingObj.city;
    NSString *buildingID = [[NSUserDefaults standardUserDefaults]objectForKey:SELECTED_BUILDING_ID];
    if ([buildingObj.buildingID isEqualToString:buildingID]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
