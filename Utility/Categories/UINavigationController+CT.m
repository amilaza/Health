//
//  UINavigationController+CT.m
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/26/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "UINavigationController+CT.h"

@implementation UINavigationController (CT)


-(NSUInteger)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate{
    return YES;
}


@end
