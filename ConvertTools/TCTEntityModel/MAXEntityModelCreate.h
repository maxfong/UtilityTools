//
//  MAXEntityModelCreate.h
//  ConvertTools
//
//  Created by maxfong on 14-9-17.
//
//

#import <Foundation/Foundation.h>
#import "MAXEntityModelReplace.h"

typedef NS_ENUM(NSUInteger, MAXSearchPathDirectory)
{
    MAXUserDesktopDirectory
};

@interface MAXEntityModelCreate : NSObject

+ (BOOL)createDirectory:(MAXSearchPathDirectory)directory error:(NSError **)error;

+ (BOOL)createFileAtPath:(NSString *)filePath contentData:(NSData *)contentData attributes:(NSDictionary *)attr;

+ (NSData *)contentWithModel:(MAXFileEntityModel)model originalData:(NSDictionary *)dictionary options:(NSDictionary *)options;

+ (NSString *)filePathWithModel:(MAXFileEntityModel)model options:(NSDictionary *)options;

@end
