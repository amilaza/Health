//
//  OptionsPickerSheetView.m
//  VPW
//
//  Created by Sunil Verma on 10/1/14.
//  Copyright (c) 2014 Halosys. All rights reserved.
//

#import "OptionsPickerSheetView.h"
#import "AppDelegate.h"

OptionPickerSheetBlock pickerBlock;
UIPickerView *picker;
NSInteger     currentPick;
NSArray      *pickerOptions;

static OptionsPickerSheetView *optionsPickerSheetView = nil;
@implementation OptionsPickerSheetView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}


+ (id)sharedPicker {
    
    if (!optionsPickerSheetView) {
        
        optionsPickerSheetView = [[OptionsPickerSheetView alloc] init];
    }
    
    return optionsPickerSheetView;
}


-(void)showPickerSheetWithOptions:(NSArray *)options AndComplitionblock:(OptionPickerSheetBlock)block
{
    pickerBlock = [block copy];
    
    pickerOptions = [[NSArray alloc] initWithArray:options];
    
    currentPick = 0;
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    picker = [[UIPickerView alloc] init];
    picker.showsSelectionIndicator =  YES;
    picker.delegate = self;
    picker.dataSource = self;
    
    
    [optionsPickerSheetView addSubview:picker];
    
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(0, 0, 50, 40);
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];

    [doneBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [doneBtn addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleColor:[UIColor colorWithRed:49.0/255 green:90.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, appDel.window.frame.size.width, 40)];
    UIBarButtonItem *doneBarBtn = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:49.0/255 green:90.0/255 blue:255.0/255 alpha:1.0] forState:UIControlStateNormal];

    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [cancelBtn addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *flexibleSpace =   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems: [NSArray arrayWithObjects:cancelBarBtn,flexibleSpace,doneBarBtn, nil] animated:NO];
    [optionsPickerSheetView addSubview:toolBar];
    
    [toolBar setBarTintColor:[UIColor colorWithRed:242.0/255 green:236.0/255 blue:235.0/255 alpha:1.0]];
    
    
    [picker selectRow:currentPick inComponent:0 animated:NO];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [picker setFrame:CGRectMake((appDel.window.frame.size.width - 320)/2, 40, 320, 216)];
        
       // NSLogInfo(@" .........  %@",NSStringFromCGRect(appDel.window.frame));
        [picker setBackgroundColor:[UIColor clearColor]];

    });
    [picker reloadAllComponents];

    UIView *tempView = [[UIView alloc] initWithFrame:appDel.window.bounds];
    [tempView setBackgroundColor:[UIColor blackColor]];
    [tempView setAlpha:0.0];
    [tempView setTag:20];
    
    
    [appDel.window addSubview:tempView];
    
    [appDel.window addSubview:optionsPickerSheetView];
    [appDel.window bringSubviewToFront:optionsPickerSheetView];
    
    optionsPickerSheetView.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 260);
    
    [UIView animateWithDuration:0.1 animations:^{
        optionsPickerSheetView.frame = CGRectMake(0, appDel.window.frame.size.height -260, appDel.window.frame.size.width, 260);
        [tempView setAlpha:0.50];
        
    } completion:^(BOOL finished) {
        
    }];
}



-(void)cancelActionSheet:(id)sender
{
    pickerBlock(nil,-1);
    [self removePickerView];
    
}
#pragma mark - Action Sheet Callback function
-(void)doneActionSheet:(id)sender{
    
    
    pickerBlock([pickerOptions objectAtIndex:currentPick],currentPick);
    [self removePickerView];
    
}

-(void)removePickerView
{
    AppDelegate *appDel = [[UIApplication sharedApplication] delegate];
    
    [UIView animateWithDuration:0.1 animations:^{
        optionsPickerSheetView.frame = CGRectMake(0, appDel.window.frame.size.height, appDel.window.frame.size.width, 260);
        
    } completion:^(BOOL finished) {
        for (id obj  in optionsPickerSheetView.subviews) {
            [obj removeFromSuperview];
        }
        [optionsPickerSheetView removeFromSuperview];
        optionsPickerSheetView =nil;
        [[appDel.window viewWithTag:20] removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDelegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return  [pickerOptions count];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    currentPick = row;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    
    if (!label)
    {
        // Customize your label (or any other type UIView) here
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, pickerView.bounds.size.width * 0.8, 25.0f)];
        
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [label setTextColor:[UIColor blackColor]];
    if (row < [pickerOptions count])
    {
        label.text = (NSString *)[pickerOptions objectAtIndex:row];
    }
    return label;
}

@end
