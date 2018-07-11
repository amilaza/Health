//
//  UIFont+CT.m
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "UIFont+CT.h"


@implementation UIFont (CT)

+(UIFont *)appHelveticaNeueLightFontWithSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+(UIFont *)appHelveticaNeueMediumFontWithSize:(CGFloat)size{
  return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)appMyraidRegularFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"MyriadPro-Regular" size:size];
}

+ (UIFont *)appMyraidSemiboldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"MyriadPro-Semibold" size:size];
}

+ (UIFont *)appMyraidBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"MyriadPro-Bold" size:size];
}

+ (UIFont *)appCandaraBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Candara-Bold" size:size];
}

+ (UIFont *)appCandaraFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Candara" size:size];
}

@end
