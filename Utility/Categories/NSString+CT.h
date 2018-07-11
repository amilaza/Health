//
//  NSString+CT.h
//  ConnectedTVApp
//
//  Created by Amit Majumdar on 8/10/15.
//  Copyright (c) 2015 Mobiloitte Technologies Pvt. Ltd. All rights reserved.
//

#import "Header.h"

@interface NSString (CT)

- (NSString *)trimWhiteSpace;
- (NSString *)replaceCharcter:(NSString *)olderChar withCharcter:(NSString *)newerChar;
- (NSString*)getSubstringFrom:(NSInteger)begin to:(NSInteger)end;
- (NSString *)addString:(NSString *)string;
- (NSString *)removeSubString:(NSString *)subString;
- (NSString *)getNewSecuredStringWithPattern:(NSString *)pattern;
- (NSString *)removeWhiteSpacesFromString;

- (NSUInteger)countNumberOfWords;

- (BOOL)isValidEmail;
- (BOOL)isValidUsername;
- (BOOL)containsString:(NSString *)subString;
- (BOOL)isBeginsWith:(NSString *)string;
- (BOOL)isEndssWith:(NSString *)string;
- (BOOL)containsOnlyLetters;
- (BOOL)containsOnlyNumbers;
- (BOOL)containsOnlyNumbersAndPlusSign;
- (BOOL)containsOnlyNumbersAndComma;
- (BOOL)containsOnlyNumbersAndLetters;
- (BOOL)isInThisarray:(NSArray*)array;
- (BOOL)isVAlidPhoneNumber;
- (BOOL)isValidUrl;
- (BOOL)isValidPassword;
- (BOOL)isValidName;
- (BOOL)isBlank;
- (BOOL)isValid;

- (NSArray *)getArray;

- (NSData *)convertToData;
- (NSData *) base64DataFromString:(NSString *)string;

- (CGFloat)getEstimatedHeightWithFont:(UIFont*)font withWidth:(CGFloat)width withExtraHeight:(CGFloat)ht;

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
+ (NSString *)getStringFromData:(NSData *)data;
+ (NSString *)getMyApplicationVersion;
+ (NSString *)getMyApplicationName;
+ (NSString *)getStringFromArray:(NSArray *)array;
+ (NSAttributedString*)getAttributedStringWithcustomFontAndColor:(NSString*)text :(NSString *)str1 :(NSString *)str2  withFont1 :(UIFont *)font1 withFont2 :(UIFont *)font2 withColor1 :(UIColor *)color1 withColor2:(UIColor *)color2;


@end
