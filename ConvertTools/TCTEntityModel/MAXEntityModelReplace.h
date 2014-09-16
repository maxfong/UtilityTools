//
//  MAXEntityModelReplace.h
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const TCTModelFileServerNameKey;    // NSString
FOUNDATION_EXPORT NSString *const TCTModelFileInterfaceKey;     // NSString

typedef NS_ENUM(NSUInteger, TCTFileEntityModel)
{
    TCTUnknownEntity,
    TCTRequestHeadEntity,
    TCTRequestComplieEntity,
    TCTRequestEntity,
    TCTResponseHeadEntity,
    TCTResponseComplieEntity,
    TCTResponseEntity,
    TCTOtherEntity NS_ENUM_AVAILABLE(10_8, 3_2) = 1024
};

@interface MAXEntityModelReplace : NSObject

+ (NSString *)replaceStringWithString:(NSString *)string object:(NSDictionary *)dictionary fileModel:(TCTFileEntityModel)fileModel options:(NSDictionary *)options;

@end
