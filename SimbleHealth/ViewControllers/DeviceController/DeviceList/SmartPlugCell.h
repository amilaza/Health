//
//  SmartPlugCell.h
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 5/22/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceInfo.h"
#import "OnOffSwitch.h"
#import "ServiceHelper.h"

@protocol SmartPlugCellDelegate <NSObject>
- (void)smartPlugCellDelegateSwitchOnAtIndexPath:(NSIndexPath *)cellIndexPath;
- (void)smartPlugCellDelegateSwitchOffAtIndexPath:(NSIndexPath *)cellIndexPath;
@end

@interface SmartPlugCell : UICollectionViewCell
<OnOffSwitchDelegate, ServiceHelperDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblOffline;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_connectionState;
@property (weak, nonatomic) IBOutlet UILabel *label_DeviceName;
@property (weak, nonatomic) IBOutlet UIView *viewDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_device;
@property (weak, nonatomic) IBOutlet UILabel *lblEnergy;
@property (weak, nonatomic) IBOutlet UIButton *button_power;
@property (weak, nonatomic) IBOutlet UIView *onOffSwicthView;
@property (weak, nonatomic) IBOutlet UILabel *lbLCost;
@property (strong, nonatomic) IBOutlet UIView *viewSwicth;

@property (weak, nonatomic) DeviceInfo *deviceInfo;
@property (weak, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) NSArray *array_deviceList;
@property (weak, nonatomic) id <SmartPlugCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *lblLastStatus;

- (void)updateSwitchFrame;
@end
