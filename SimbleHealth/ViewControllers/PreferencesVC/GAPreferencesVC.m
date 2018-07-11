//
//  GAPreferencesVC.m
//  ElectricityVersion2
//
//  Created by Abhishek on 08/12/15.
//  Copyright © 2015 Mobiloitte Inc. All rights reserved.
//

#import "GAPreferencesVC.h"
#import "Header.h"
#import "CustomStepper.h"

typedef NS_ENUM(NSInteger, StepperType) {
    StepperTypeOccupants = 10,
    StepperTypeBudgetKWh = 11,
    StepperTypeBudgetMoney = 12,
    StepperTypeSolar = 13,
    StepperTypeTolerance = 14
};
@interface GAPreferencesVC () {
    
    NSArray *arrayOfSize;
    UserPreference *preference;
}

@property (weak, nonatomic) IBOutlet UIView *viewQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnQuestion;
@property (weak, nonatomic) IBOutlet UITextField *tfStepperTolerance;
@property (weak, nonatomic) IBOutlet UITextField *tfStepperSolar;
@property (weak, nonatomic) IBOutlet CustomStepper *stepperBudgetKWh;
@property (weak, nonatomic) IBOutlet CustomStepper *stepperBudgetMoney;

@property (weak, nonatomic) IBOutlet CustomStepper *stepperSolar;
@property (weak, nonatomic) IBOutlet CustomStepper *stepperTolerance;
@property (strong, nonatomic) IBOutlet CustomStepper *stepper;

@property (strong, nonatomic) IBOutlet UILabel *label_stepper;
@property (strong, nonatomic) IBOutlet UILabel *label_houseSize;
@property (strong, nonatomic) IBOutlet UIButton *button_houseSize;
@property (strong, nonatomic) IBOutlet UITextField *textField_monthlyBudgetKwh;
@property (strong, nonatomic) IBOutlet UITextField *textField_monthlyBudgetPond;
@property (strong, nonatomic) IBOutlet UISwitch *switch_pushEnable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewQuestionConstraint;

- (IBAction)buttonAction_cross:(id)sender;
- (IBAction)stepperAction:(id)sender;
- (IBAction)buttonAction_houseSize:(id)sender;

@end

@implementation GAPreferencesVC

#pragma mark - Life Cycle Method

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //get a local instance for saved preference
    preference = [[AppUser sharedUser] preference];

    //set up UI and other stuff
    [self setUpInitials];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    //log event
    //[[GAHelper instance] sendEventOfType:LogType_PreferenceScreen forUser:[AppUser sharedUser]];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppUser *user = [AppUser sharedUser];
    [preference savePreferenceForUser:user.email];
}
#pragma mark - Helper Method

-(void)setSteeper{
    self.stepper.value = [preference.numberOfPeople integerValue];
    self.label_stepper.text = [NSString stringWithFormat:@"%.0f",self.stepper.value];
    self.stepper.minimumValue = 0;
    self.stepper.maximumValue = 12;
    self.stepper.tag = StepperTypeOccupants;
    //
    
    self.textField_monthlyBudgetPond.text = preference.monthlyBudget_kwh;
    self.stepperBudgetKWh.value = [preference.monthlyBudget_kwh integerValue];
    self.textField_monthlyBudgetKwh.text = [NSString stringWithFormat:@"%.0f",self.stepperBudgetKWh.value];
    
    self.stepperBudgetKWh.minimumValue = 0;
    self.stepperBudgetKWh.tag = StepperTypeBudgetKWh;
    //
    
    self.stepperBudgetMoney.value = [preference.monthlyBudget_pound integerValue];
    self.textField_monthlyBudgetPond.text = [NSString stringWithFormat:@"%.0f",self.stepperBudgetMoney.value];
    self.stepperBudgetMoney.minimumValue = 0;
    self.stepperBudgetMoney.tag = StepperTypeBudgetMoney;
    //
    
    self.stepperSolar.value = [preference.solarSize integerValue];

    self.tfStepperSolar.text = [NSString stringWithFormat:@"%.0f",self.stepperSolar.value];
    self.stepperSolar.minimumValue = 0;
    self.stepperSolar.tag = StepperTypeSolar;
    //
    
    self.stepperTolerance.value = [preference.numberOfPeople integerValue];
    self.tfStepperTolerance.text = [NSString stringWithFormat:@"%.0f",self.stepperTolerance.value];
    self.stepperTolerance.minimumValue = 0;
    self.stepperTolerance.maximumValue = 32;
    self.stepperTolerance.tag = StepperTypeTolerance;
    //
}
-(void)setUpInitials {
    _btnQuestion.selected = YES;
    [self touchQuestion:nil];
    self.btnQuestion.layer.cornerRadius = self.btnQuestion.frame.size.height/2;
    //set Stepper
    [self setSteeper];
    
    //setCorner Of View
    setLabelBorder(_label_houseSize);
    
    setTextFieldBorder(_textField_monthlyBudgetKwh);
    setTextFieldBorder(_textField_monthlyBudgetPond);
    setTextFieldBorder(_tfStepperSolar);
    setTextFieldBorder(_tfStepperTolerance);
    setButtonBorder(_button_houseSize);
    
    //array Initialization
    arrayOfSize = [[NSArray alloc] initWithObjects:@"Short", @"Medium", @"Large", nil];

    //set Text of textField
    
    self.textField_monthlyBudgetKwh.text = preference.monthlyBudget_kwh;
    self.textField_monthlyBudgetPond.text = preference.monthlyBudget_pound;
    self.tfStepperSolar.text = preference.solarSize;
    
    //set The label vlaue
    self.label_houseSize.text = preference.houseSize;
    self.label_stepper.layer.borderWidth = 1;
    self.label_stepper.layer.borderColor = [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1].CGColor;
    
    self.textField_monthlyBudgetKwh.inputAccessoryView = toolBarForNumberPad(self, @"Done");
    self.textField_monthlyBudgetPond.inputAccessoryView = toolBarForNumberPad(self, @"Done");
    
    [self.switch_pushEnable setOn:preference.pushEnabled animated:NO];
}

#pragma mark - UITextField Delegate Methods

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _textField_monthlyBudgetKwh) {
        preference.monthlyBudget_kwh =  TRIM_SPACE(textField.text);
    }
    else if (textField == _textField_monthlyBudgetPond) {
        preference.monthlyBudget_pound  = TRIM_SPACE(textField.text);
    } else if (textField == _tfStepperSolar){
        preference.solarSize = TRIM_SPACE(textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if(textField.returnKeyType == UIReturnKeyDone){
        [self.view endEditing:YES];
        return YES;
    }
    
    return NO;
}

#pragma mark - Memory Management Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons Action Methods

-(void)doneWithNumberPad {
    [self.view endEditing: YES];
}

- (IBAction)buttonAction_cross:(id)sender {
    
    AppUser *user = [AppUser sharedUser];

    [preference savePreferenceForUser:user.email];
    
    if ((user.device!= nil) && ((user.device.deviceSensorType == DeviceSensorType_PulseReader) && (user.device.deviceSensorUtility == DeviceSensorUtility_Electricity))) {
        
        //api call when user go away from this screen and if sensorType=”PULSEREADER” and sensorUtility=”ELECTRICITY”
        [self callApiForBudget:user];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)touchQuestion:(id)sender {
    _btnQuestion.selected = !_btnQuestion.selected;
    if (_btnQuestion.selected == NO) {
        self.viewQuestionConstraint.constant = 30;
        _btnQuestion.selected = NO;
        _viewQuestion.hidden = YES;
    } else {
        self.viewQuestionConstraint.constant = 60;
        _btnQuestion.selected = YES;
        _viewQuestion.hidden = NO;
    }
}

- (IBAction)stepperAction:(id)sender {
    
    
}

- (IBAction)switchAction:(UISwitch *)sender {
    preference.pushEnabled = sender.isOn;
}
- (IBAction)touchStepper:(UIStepper *)sender {
    if (sender.tag == StepperTypeOccupants) {
        self.label_stepper.text = [NSString stringWithFormat:@"%.0f", self.stepper.value];
        preference.numberOfPeople = self.label_stepper.text;
    } else if (sender.tag == StepperTypeBudgetKWh) {
        self.textField_monthlyBudgetKwh.text = [NSString stringWithFormat:@"%.0f", self.stepperBudgetKWh.value];
        preference.monthlyBudget_kwh = self.textField_monthlyBudgetKwh.text;
    } else if (sender.tag == StepperTypeBudgetMoney) {
        self.textField_monthlyBudgetPond.text = [NSString stringWithFormat:@"%.0f", self.stepperBudgetMoney.value];
        preference.monthlyBudget_pound = self.textField_monthlyBudgetPond.text;
    } else if (sender.tag == StepperTypeSolar) {
        self.tfStepperSolar.text = [NSString stringWithFormat:@"%.0f", self.stepperSolar.value];
        preference.solarSize = self.tfStepperSolar.text;
    } else if (sender.tag == StepperTypeTolerance) {
         self.tfStepperTolerance.text = [NSString stringWithFormat:@"%.0f", self.stepperTolerance.value];
    }
}

- (IBAction)buttonAction_houseSize:(id)sender {
    
     [[OptionsPickerSheetView sharedPicker] showPickerSheetWithOptions:arrayOfSize AndComplitionblock:^(NSString *selectedText, NSInteger selectedIndex) {
         self.label_houseSize .text = selectedText;
         preference.houseSize = selectedText;
     }];
}

#pragma mark - Service Helper Methods

-(void)callApiForBudget:(AppUser*)user {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setValue:user.email forKey:@"customerID"];
    [paramDict setValue:[[user device] circuitID] forKey:@"circuitID"];
    [paramDict setValue:@"ELECTRICITY" forKey:@"utility"];
    [paramDict setValue:user.preference.monthlyBudget_pound forKey:@"monetaryThreshold"];
    [paramDict setValue:user.preference.monthlyBudget_kwh forKey:@"consumptionThreshold"];
    
    ServiceHelper *appWebEngine = [[ServiceHelper alloc] init];
    [appWebEngine setServiceHelperDelegate:nil];
    [appWebEngine callPOSTMethodWithData:paramDict andMethodName:WebMethodType_Budget andController:nil headerValue:user.token];
}

@end
