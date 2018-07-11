//
//  UIViewController+CT.h
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "Header.h"
@class AppDelegate;


@interface UIViewController (CT)

-(AppDelegate *)getAppDelegate;

-(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
-(double)getWindowWidth;
-(double)getWindowHeight;
-(BOOL)isIPad;
-(UIWindow *)getMainWindow;

-(void)showReachablityAlert;
-(void)showNotificationAlertWithTitle:(NSString *)title andMessage:(NSString *)message withBackgroundColor:(UIColor *)backgroundColor andStrokeColor:(UIColor *)strokeColor andInfoImage:(UIImage *)infoImage;

-(void)showNotificationInfoAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
-(void)showNotificationErrorAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
-(void)showNotificationSuccessAlertWithTitle:(NSString *)title andMessage:(NSString *)message;
-(void)animateView:(UIView *)contentView WithDuration:(CGFloat)duration toConstraint:(NSLayoutConstraint *)constraint appliedWithConstantValue:(float)constantVal;
-(NSString *)timeToHumanString:(unsigned long)ms;

@end
