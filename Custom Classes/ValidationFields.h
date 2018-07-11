//
//  ValidationFields.h
//  GEO SPORTS
//
//  Created by Abhishek Tyagi on 07/12/15.
//  Copyright © 2015 Mobiloitte Inc.com. All rights reserved.
//

#import "Header.h"
@interface ValidationFields : NSObject

+(BOOL)validateFirstName:(NSString *)firstName;
+(BOOL)validateLastName:(NSString *)lastName;
+(BOOL)validatePhoneNumber:(NSString *)phoneNumber;
+(BOOL)validateMobileNumber:(NSString *)mobileNumber;
+(BOOL)validateEmailAddress:(NSString *)emailAddress;
+(BOOL)validateAddress:(NSString *)address;
+(BOOL)validateUsername:(NSString *)userName;
+(BOOL)validateName:(NSString *)name;
+(BOOL) validateUrl: (NSString *) candidate ;
+(NSString*)getTimeRemaining:(NSString*)timeStampString;
@end
