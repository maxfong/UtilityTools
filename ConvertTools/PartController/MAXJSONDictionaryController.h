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
+ (NSDictionary *)json2Dictionary:(NSString *)jsonString error:(NSError **)error;

/**
 *  检查JSON是否正确
 *
 *  @param jsonString JSON string
 *
 *  @return true is nil
 */
+ (NSError *)checkJSON:(NSString *)jsonString;

/**
 *  返回错误描述
 *
 *  @param error error
 *
 *  @return 文案
 */
+ (NSString *)jsonErrorDescription:(NSError *)error;

/**
 *  JSON具体的错误点
 *
 *  @param error
 *  @param originString
 *
 *  @return
 */
+ (NSString *)jsonSpecificError:(NSError *)error originString:(NSString *)originString;

/**
 *   格式化Dictionary展示
 *
 *  @param dictionary
 *  @param space      排版空白
 *
 *  @return 展示文案
 */
+ (NSString *)formatDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space;

@end
