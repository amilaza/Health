#import <Foundation/Foundation.h>

typedef NS_ENUM (short, ClassType) {
 
    Number,
    String,
    Dictionary,
    Array
};

@interface NSDictionary (Extended)

-(id)objectForKey:(id)key expectedType:(ClassType)type;

@end
