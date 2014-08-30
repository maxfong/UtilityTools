//
//  MAXJSONDictionaryController.h
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import <Foundation/Foundation.h>

@interface MAXJSONDictionaryController : NSObject

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
 *  @return 文案
 */
+ (NSString *)JSONDescriptionWithError:(NSError *)error;

/**
 *  JSON具体的错误点
 *
 *  @param error
 *  @param originString
 *
 *  @return
 */
+ (NSString *)JSONSpecificFromError:(NSError *)error originString:(NSString *)originString;

/**
 *   格式化Dictionary展示
 *
 *  @param dictionary
 *  @param space      排版空白
 *
 *  @return 展示文案
 */
+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space;

@end
