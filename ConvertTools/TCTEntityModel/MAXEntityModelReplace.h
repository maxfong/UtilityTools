//
//  MAXEntityModelReplace.h
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString *const MAXModelFileServerNameKey;    // NSString
FOUNDATION_EXPORT NSString *const MAXModelFileInterfaceKey;     // NSString
FOUNDATION_EXPORT NSString *const MAXModelFilePrefixKey;        // NSString
FOUNDATION_EXPORT NSString *const MAXModelFileSuperClassKey;    // NSString
FOUNDATION_EXPORT NSString *const MAXModelFileImportKey;        // NSString
FOUNDATION_EXPORT NSString *const MAXModelFileInitKey;        // NSString

typedef NS_ENUM(NSUInteger, MAXFileEntityModel)
{
    MAXUnknownEntity,
    MAXHeadEntity = 'h',
    MAXComplieEntity = 'm',
    MAXHeadAndComplieEntity,
    MAXOtherEntity NS_ENUM_AVAILABLE(10_8, 3_2) = 1024
};

@interface MAXEntityModelReplace : NSObject

+ (NSString *)replaceStringWithString:(NSString *)string object:(NSDictionary *)dictionary fileModel:(MAXFileEntityModel)fileModel options:(NSDictionary *)options;

@end
