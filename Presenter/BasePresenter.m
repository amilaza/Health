//
//  BasePresenter.m
//  ElectricityVersion2
//
//  Created by Nguyen Ba Linh on 9/11/17.
//  Copyright © 2017 Mobiloitte Inc. All rights reserved.
//

#import "BasePresenter.h"
#import "Header.h"

@implementation BasePresenter
- (NSError *)createErrorWithDescription:(NSString *)message
{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: message};
    NSError *error = [[NSError alloc] initWithDomain:[[NSBundle mainBundle] bundleIdentifier] code:999 userInfo:userInfo];
    return error;
}

- (NSError *)createErrorFromResponse:(id)responseObject {
    NSString *message;
    NSError *responseError;
    if (responseObject == nil) {
        message = DEFAULT_MESSAGE;
        return [self createErrorWithDescription:message];
    }
    NSMutableDictionary *dictError = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&responseError];
    if ([[dictError allKeys] containsObject:@"message"]) {
        message = dictError[@"message"];
    } else {
        message = DEFAULT_MESSAGE;
    }
    return [self createErrorWithDescription:message];
}
@end
