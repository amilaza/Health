//
//  UIViewController+CT.m
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "UIViewController+CT.h"

@implementation UIViewController (CT)


-(AppDelegate *)getAppDelegate{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return appDelegate;
}

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [[[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil]show];
}

-(double)getWindowWidth{
    return [[UIScreen mainScreen]bounds].size.width;
}

-(double)getWindowHeight{
    return [[UIScreen mainScreen]bounds].size.height;
}

-(BOOL)isIPad{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

-(UIWindow *)getMainWindow{
  return  [[self getAppDelegate] window];
}


-(void)showReachablityAlert{
    
}
-(void)showNotificationAlertWithTitle:(NSString *)title
                                   andMessage:(NSString *)message
                      withBackgroundColor:(UIColor *)backgroundColor
                              andStrokeColor:(UIColor *)strokeColor
                              andInfoImage:(UIImage *)infoImage{
    
}

-(void)showNotificationInfoAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
    [self showNotificationAlertWithTitle:title andMessage:message withBackgroundColor:[UIColor redColor] andStrokeColor:[UIColor blackColor] andInfoImage:[UIImage imageNamed:@"icon-info.png"]];
}
-(void)showNotificationErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
}
-(void)showNotificationSuccessAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    
}

-(void)animateView:(UIView *)contentView WithDuration:(CGFloat)duration toConstraint:(NSLayoutConstraint *)constraint appliedWithConstantValue:(float)constantVal{
    
    constraint.constant = constantVal;
    [contentView setNeedsUpdateConstraints];
    [UIView animateWithDuration:duration animations:^{
        [contentView layoutIfNeeded];
    }];
}


-(NSString *)timeToHumanString:(unsigned long)ms
{
    unsigned long seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = ms / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
    nsRet = [[NSString alloc] initWithCString:buff
                                      encoding:NSUTF8StringEncoding];
    
    return nsRet;
}


//- (void)manageDurationWithAnimation:(CGFloat)withValue duration:(CGFloat)duration constraint :(NSLayoutConstraint *)cnst {
//    
//    [UIView beginAnimations:@"MoveView" context:nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:duration];
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.controlView cache:YES];
//    [cnst setConstant:withValue];
//    [self.view layoutSubviews];
//    [UIView commitAnimations];
//}

@end
