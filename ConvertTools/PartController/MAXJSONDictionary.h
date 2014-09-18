//
//  MAXJSONDictionary.h
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import <Foundation/Foundation.h>

@interface MAXJSONDictionary : NSObject

/**
 *  JSON转换为Dictionary
 *
 *  @param jsonString JSON string
 *  @param error      error
 *
 *  @return Dictionary
 */
+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString error:(NSError **)error;

/**
 *  Dictionary转换为JSON
 *
 *  @param dictionary dictionary
 *  @param error      error
 *
 *  @return JSONString
 */
+ (NSString *)JSONStringWithDictionary:(NSDictionary *)dictionary error:(NSError **)error;

/**
 *  检查JSON是否正确
 *
 *  @param jsonString JSON string
 *
 *  @return true is nil
 */
+ (BOOL)validityJSONString:(NSString *)jsonString error:(NSError **)error;

/**
 *  返回错误描述
 *
 *  @param error error
 *
 *  @return sting
 */
+ (NSString *)JSONDescriptionWithError:(NSError *)error;

/**
 *  JSON具体的错误点
 *
 *  @param error
 *  @param originString
 *
 *  @return string
 */
+ (NSString *)JSONSpecificFromError:(NSError *)error originString:(NSString *)originString;

/**
 *   压缩JSON String
 *
 *  @param JSONString
 *
 *  @return 压缩后string
 */
+ (NSString *)compressJSONString:(NSString *)JSONString;

/**
 *   格式化Dictionary展示
 *
 *  @param dictionary
 *
 *  @return string
 */
+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary;

@end
