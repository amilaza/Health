//
//  UIImage+CT.h
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/11/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "Header.h"

@interface UIImage (CT)

+ (UIImage *)imageFromColor:(UIColor *)color;
+(UIImage *)backButton;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)blurredImageWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(UIImage *)maskImage;
@end
