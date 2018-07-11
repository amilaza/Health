//
//  OptionPickerSheet.m
//  mColleagues
//
//  Created by Sunil Verma on 24/06/13.
//  Copyright (c) 2013 Halosys. All rights reserved.
//

#import "OptionPickerSheet.h"
#import "Header.h"
#define kPickerViewTag 50001

@interface OptionPickerSheet()
@end

@implementation OptionPickerSheet
@synthesize odelegate = _odelegate;
@synthesize odatasource = _odatasource;
@synthesize currentPick;

#pragma mark - UIPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        currentPick = 0;
    }
    return self;
}
/**
 * show picker sheet
 * @pram picker elements and picker title
 */
- (void)showPickerSheetWithOptions:(NSArray*)options title:(NSString*)title{
    
    pickerOptions = [NSArray arrayWithArray:options];
    
       [self showWithTitle:title];
}

/**
 * show picker sheet
 * @pram picker elements
 */
- (void)showPickerSheetWithOptions:(NSArray*)options{
    pickerOptions = [NSArray arrayWithArray:options];
       
       [self showWithTitle:nil];
}

/**
 * show title on picker sheet
 * @pram picker title
 */
- (void)showWithTitle:(NSString*)title {
    
    picker = (UIPickerView*)[self viewWithTag:kPickerViewTag];
    picker.showsSelectionIndicator = NO;
    if (picker){
        [picker reloadAllComponents];
    }
    else{
        CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
       
        picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
        picker.tag = kPickerViewTag;
        picker.showsSelectionIndicator =  YES;
        picker.delegate = self;
        [picker selectRow:currentPick inComponent:0 animated:NO];
        
        [self addSubview:picker];
        
        self.delegate = self;
        
        UISegmentedControl *donebutton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Done"]];
        donebutton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
//        donebutton.segmentedControlStyle = UISegmentedControlStyleBar;
        donebutton.tintColor = [UIColor blackColor];
        [donebutton addTarget:self action:@selector(doneActionSheet:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:donebutton];
        
        
        UISegmentedControl *cancelbutton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
        cancelbutton.frame = CGRectMake(10, 7.0f, 70.0f, 30.0f);
//        cancelbutton.segmentedControlStyle = UISegmentedControlStyleBar;
        cancelbutton.tintColor = [UIColor blackColor];
        [cancelbutton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:cancelbutton];
        
        if (title){
            UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(90, 5.0f, 250.0f, 30.0f)];
            label.textColor = [UIColor blackColor];
            label.backgroundColor = [UIColor clearColor];
            UIFont *myFont = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18.0];
            label.font = myFont;
            label.text = [title uppercaseString];
            [self addSubview:label];
        }
    }

    [self showInView:[[UIApplication sharedApplication] keyWindow]];
    [self setBounds:CGRectMake(0, 0, 320, 485)];
}

-(void)cancelActionSheet:(id)sender
{
    [self dismissWithClickedButtonIndex:0 animated:YES ];

}
#pragma mark - Action Sheet Callback function
-(void)doneActionSheet:(id)sender{
  
    [self dismissWithClickedButtonIndex:0 animated:YES ];
    
    [_odelegate pickerSheet:self didSelectOption:[pickerOptions objectAtIndex:currentPick]];


}

#pragma mark - UIPickerViewDelegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    //DebugLog(@"start");
    return  [pickerOptions count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
       return 1;
}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//
//   // return [pickerOptions objectAtIndex:row];
//}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
   
    currentPick = row;
   
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    
    if (!label)
    {
        // Customize your label (or any other type UIView) here
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 5.0f, pickerView.bounds.size.width * 0.8, 25.0f)];
        
        [label setTextAlignment:NSTextAlignmentCenter];
    }
    
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"TrebuchetMS-Bold" size:16.0]];
    if (row < [pickerOptions count])
    {
        label.text = (NSString *)[pickerOptions objectAtIndex:row];
       
    }
    
    return label;
}



@end
