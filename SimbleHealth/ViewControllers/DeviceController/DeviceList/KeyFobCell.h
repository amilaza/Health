//
//  KeyFobCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 7/3/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"

@interface KeyFobCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imvConnectionState;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imvDevice;
@property (weak, nonatomic) IBOutlet UIImageView *imvKeyfob;
@property (weak, nonatomic) IBOutlet UILabel *lblKeyfob;
@property (weak, nonatomic) IBOutlet UIButton *button_power;
@property (strong, nonatomic) IBOutlet UIView *viewOutOfRange;
@property (strong, nonatomic) IBOutlet UIView *viewKeyFob;
@property (strong, nonatomic) IBOutlet UIView *viewDash;
@property (strong, nonatomic) IBOutlet UIView *viewOnline;
@property (strong, nonatomic) IBOutlet UIImageView *imvOutOfRange;
@property (strong, nonatomic) IBOutlet UIView *viewLowBattery;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStatus;


@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@end
