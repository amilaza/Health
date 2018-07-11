#import "NSDictionary+Extended.h"

@implementation NSDictionary (Extended)

-(id)objectForKey:(id)key expectedType:(ClassType)type {
    
    id object = [self objectForKey:key];
    
    Class className = [self getClassNameForType:type];
    
    // added helper to check if in case we are getting number from server but we want a string from it
    if ([object isKindOfClass:[NSNumber class]] && (className == [NSString class])) {
        object = [object stringValue];
    }
    // checking if in case object is nil OR checking if object is of desired class
    else if ((object == nil) || (object == [NSNull null]) || ([object isKindOfClass:className] == NO)) {
        object = [className new];
    }
    // checking if in case object if of string type and we are getting nil inside quotes
   	else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@"<null>"] || [object isEqualToString:@"(null)"]) {
            object = [className new];
        }
    }
    
    return object;
}

-(Class)getClassNameForType : (ClassType)type {
    
    Class className;
    
    switch (type) {
            
        case Number: className = [NSNumber class]; break;
        case String: className = [NSString class]; break;
        case Dictionary: className = [NSDictionary class]; break;
        case Array: className = [NSArray class]; break;
        default: break;
    }
    
    return className;
}

@end
