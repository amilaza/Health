//
//  SmokeCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 7/19/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
#import "FlickerImageView.h"

@interface SmokeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imvConnectionState;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imvDevice;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UIImageView *imvSmoke;
@property (weak, nonatomic) IBOutlet UILabel *lblSmoke;
@property (weak, nonatomic) IBOutlet UIButton *button_power;
@property (strong, nonatomic) IBOutlet UIView *viewLowBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStatus;
@property (strong, nonatomic) IBOutlet FlickerImageView *imvBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblBattery;

@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@end
