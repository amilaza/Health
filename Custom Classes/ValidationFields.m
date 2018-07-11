//
//  ValidationFields.m
//  GEO SPORTS
//
//  Created by Abhishek Tyagi on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc.com. All rights reserved.
//

#import "ValidationFields.h"

@implementation ValidationFields
+(BOOL)isStringVerified:(NSString*)string withPattern:(NSString*)pattern {
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateUsername:(NSString *)userName {
    
    NSString *exprs = @"^[A-Z0-9a-z._]+$";
    return [ValidationFields isStringVerified:userName withPattern:exprs];
}

+(BOOL)validateName:(NSString *)name {
    
    NSString *exprs =@"^[a-zA-Z\\s]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:name options:0 range:NSMakeRange(0, [name length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateEmailAddress:(NSString *)emailAddress {
    
    NSString *exprs = @"^(\\w[.]?)*\\w+[@](\\w[.]?)*\\w+[.][a-z]{2,4}$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:emailAddress options:0 range:NSMakeRange(0, [emailAddress length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateFirstName:(NSString *)firstName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:firstName options:0 range:NSMakeRange(0, [firstName length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validateLastName:(NSString *)lastName {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *match = [expr firstMatchInString:lastName options:0 range:NSMakeRange(0, [lastName length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateAddress:(NSString *)address {
    
    NSString *exprs =@"^[a-zA-Z]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:address options:0 range:NSMakeRange(0, [address length])];
    return (match ? FALSE : TRUE);
}

+(BOOL)validateMobileNumber:(NSString *)mobileNumber {
    
    NSString *exprs =@"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:mobileNumber options:0 range:NSMakeRange(0, [mobileNumber length])];
    
    return (match ? FALSE : TRUE);
}

+(BOOL)validatePhoneNumber:(NSString *)phoneNumber {
    
    NSString *exprs = @"^[0-9]+$";
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:exprs options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:phoneNumber options:0 range:NSMakeRange(0, [phoneNumber length])];
    return (match ? FALSE : TRUE);
}


+(BOOL)validateUrl: (NSString *) candidate {
    
    
    NSString *urlRegEx =  @"^([a-zA-Z0-9]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)+[a-zA-Z]{2,6}$";
    
    NSRegularExpression *expr = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:
                                 NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *match = [expr firstMatchInString:candidate options:0 range:NSMakeRange(0, [candidate length])];
    
    return (match ? FALSE : TRUE);
}
+(NSString*)getTimeRemaining:(NSString*)timeStampString{
    
    NSString *_timeElapsed = nil;
    
    NSTimeInterval noOfSec = [[NSDate date] timeIntervalSince1970] - [timeStampString floatValue];

    int sec = fabs(noOfSec);
    int days = fabs(noOfSec / (60 * 60 * 24));
    int hours = fabs(noOfSec / (60 * 60));
    int minutes = fabs(noOfSec / 60);
    int weeks = days/7;
    if (noOfSec<0) {
        _timeElapsed = @"Just Now";
    }
    else{
        if (weeks == 0) {
            if (days == 0) {
                if (hours == 0) {
                    if (minutes == 0) {
                        _timeElapsed = (sec == 1 )?[NSString stringWithFormat:@"%d sec ago",sec]:[NSString stringWithFormat:@"1 min ago"];
                    }
                    else{
                        _timeElapsed = (minutes == 1)?[NSString stringWithFormat:@"%d min ago",minutes]:[NSString stringWithFormat:@"%d minutes ago",minutes];
                    }
                }
                else{
                    _timeElapsed = (hours == 1)?[NSString stringWithFormat:@"%d hour ago",hours]:[NSString stringWithFormat:@"%d hours ago",hours];
                }
            }
            else{
                _timeElapsed = (days == 1)?[NSString stringWithFormat:@"%d day ago",days]:[NSString stringWithFormat:@"%d days ago",days];
            }
        }
        else{
            _timeElapsed = (weeks == 1)? [NSString stringWithFormat:@"%d week ago",weeks]:[NSString stringWithFormat:@"%d weeks ago",weeks];
        }
    }
    return _timeElapsed;
}



@end
