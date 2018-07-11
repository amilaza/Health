    //
//  MyDevicePopupViewController.m
//  ElectricityVersion2
//
//  Created by Aditi Tiwari on 17/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "MyDevicePopupViewController.h"
#import "header.h"

@interface MyDevicePopupViewController () <NIDropDownDelegate> {
    
    NIDropDown *dropDown;
}

@property (strong, nonatomic) NSMutableArray *array_subType;
@property (strong, nonatomic) IBOutlet UIView *view_background;

@property(strong,nonatomic) IBOutlet UITextField *textField_deviceName;
@property(strong,nonatomic) IBOutlet UIButton *button_subTypeDropDown;
@property(strong,nonatomic) IBOutlet UIImageView *imageView_dropDownIcon;
@property(strong,nonatomic) IBOutlet UITextField *textField_deviceSubType;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraint_viewHeight;

@end

@implementation MyDevicePopupViewController

#pragma mark - UIView Controller Life Cycle Methode
- (void)viewDidLoad  {
    
    [super viewDidLoad];
    [self setUpOnLoad];
}

#pragma Mark - Other HelpFul Methode
-(void)setUpOnLoad {
    
    //array Intializatin
    self.array_subType = [NSMutableArray arrayWithObjects:@"Lighting", @"Kitchen appliance", @"Ac heater", @"Custom item", nil];

    //setBorder of UIControl
    self.textField_deviceName.textColor = [UIColor lightGrayColor];
    self.textField_deviceName.layer.borderWidth = 1.0;
    self.textField_deviceName.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:195.0/255 blue:195.0/255 alpha:0.5]CGColor];
    self.textField_deviceName.layer.masksToBounds = YES;
    
    self.textField_deviceSubType.textColor = [UIColor lightGrayColor];
    self.textField_deviceSubType.layer.borderWidth = 1.0;
    self.textField_deviceSubType.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:195.0/255 blue:195.0/255 alpha:0.5]CGColor];
    self.textField_deviceSubType.layer.masksToBounds = YES;
    
    self.button_subTypeDropDown.layer.borderWidth = 1.0;
    self.button_subTypeDropDown.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:195.0/255 blue:195.0/255 alpha:0.5]CGColor];
    self.button_subTypeDropDown.layer.masksToBounds = YES;
    
    self.imageView_dropDownIcon.layer.borderWidth = 1.0;
    self.imageView_dropDownIcon.layer.borderColor = [[UIColor colorWithRed:195.0/255 green:195.0/255 blue:195.0/255 alpha:0.5]CGColor];
    self.imageView_dropDownIcon.layer.masksToBounds = YES;
    
    //setData on Default
    self.textField_deviceName.text = self.deviceInfo.name;
    [self setCircuitSubType:self.deviceInfo.circuitSubtype];
    
    if (self.deviceInfo.deviceSensorType == DeviceSensorType_SmartPlug) {
        self.constraint_viewHeight.constant = 285.0;
        [self.button_subTypeDropDown setHidden:NO];
        [self.imageView_dropDownIcon setHidden:NO];
    }
    else {
        self.constraint_viewHeight.constant = 220.0;
        [self.button_subTypeDropDown setHidden:YES];
        [self.imageView_dropDownIcon setHidden:YES];
    }
    [self.view layoutIfNeeded];
}

-(void)setCircuitSubType:(NSString*)circuitSubType {
    
    self.textField_deviceSubType.text = circuitSubType;
    
    BOOL isCustomItem = YES;
    
    for (NSString *subtype in [self.array_subType subarrayWithRange:NSMakeRange(0, self.array_subType.count-1)]) {
        if ([circuitSubType isEqualToString:subtype]) {
            isCustomItem = NO;
            break;
        }
    }
    
    if (isCustomItem) {
        [self.button_subTypeDropDown setTitle:@"Custom item"  forState:UIControlStateNormal];
        self.textField_deviceSubType.userInteractionEnabled = YES;
    }
    else {
        [self.button_subTypeDropDown setTitle:circuitSubType  forState:UIControlStateNormal];
        self.textField_deviceSubType.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)deviceNameDropDownAction:(id)sender {
    
    [self.view endEditing:YES];
    dropDown.delegate = self;
    
    if(dropDown == nil) {
        
        dropDown = [[[NIDropDown alloc] init] showDropDownWith:self.button_subTypeDropDown :sender :20 :_array_subType :@"down"];
        dropDown.delegate = self;
    }
    else {
        
        [dropDown hideDropDown:sender];
        dropDown = nil;
    }
}

#pragma mark - UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.returnKeyType == UIReturnKeyDone){
        [self.view endEditing:YES];
        return YES;
    }
    
    return NO;
}

#pragma mark - NIDropDown delegate method

-(void)didSelectWithName:(NSString*)name andSelIndex:(NSInteger)index {
    
    [self.view endEditing:YES];
    
    [self setCircuitSubType:name];
    if ([name isEqualToString:@"Custom item"]) [self.textField_deviceSubType becomeFirstResponder];
    
    dropDown = nil;
}

#pragma mark - IBAction
- (IBAction)cancelButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    if (self && self.delegate && [self.delegate respondsToSelector:@selector(devicePopUpShouldDismissWithName:andSubtype:)]) {
        [self.delegate devicePopUpShouldDismissWithName:nil andSubtype:nil];
    }
}

- (IBAction)okButtonAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    if (self && self.delegate && [self.delegate respondsToSelector:@selector(devicePopUpShouldDismissWithName:andSubtype:)]) {
        [self.delegate devicePopUpShouldDismissWithName:self.textField_deviceName.text andSubtype:self.textField_deviceSubType.text];
    }
}

@end
