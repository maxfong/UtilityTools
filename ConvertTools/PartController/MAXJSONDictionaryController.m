//
//  MAXJSONDictionaryController.m
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import "MAXJSONDictionaryController.h"

@implementation MAXJSONDictionaryController

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString error:(NSError **)error
{
    NSData *JSONData = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:JSONData
                                                               options:NSJSONReadingMutableLeaves
                                                                 error:error];
    return dictionary;
}

+ (NSString *)JSONStringWithDictionary:(NSDictionary *)dictionary error:(NSError **)error
{
    id JSONObject = dictionary ?: @"";
    NSData *data = [NSJSONSerialization dataWithJSONObject:JSONObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: nil;
}

+ (BOOL)validityJSONString:(NSString *)jsonString error:(NSError **)error
{
    NSDictionary *dictionary = [self dictionaryWithJSONString:jsonString error:error];
    return (dictionary ? YES : NO);
}

+ (NSString *)JSONDescriptionWithError:(NSError *)error
{
    return [error.userInfo valueForKey:@"NSDebugDescription"];
}

+ (NSString *)JSONSpecificFromError:(NSError *)error originString:(NSString *)originString
{
    if (error)
    {
        NSString *string = [self JSONDescriptionWithError:error];
        NSArray *array = [string componentsSeparatedByString:@" "];
        if ([array count] > 0)
        {
            NSString *s = [[array lastObject] substringToIndex:[[array lastObject] length] - 1];
            
            NSUInteger maxCount = [originString length];
            NSUInteger location = [s intValue];
            
            NSUInteger length = 10;
            while (length + location > maxCount)
            {
                length -= 1;
            }
            
            NSRange range = NSMakeRange(location, length);
            NSRange ran = NSMakeRange([s intValue], 1);
            
            NSString *message = [originString substringWithRange:range];
            NSString *errorMsg = [originString substringWithRange:ran];
            return [NSString stringWithFormat:@"%@->%@", message, errorMsg];
        }
    }
    return nil;
}

+ (NSString *)stringFromDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space
{
    NSMutableString *string = [NSMutableString string];
    
    NSMutableString *spaceString = [NSMutableString stringWithString:@"  "];
    NSString *s = @"";
    if ([space length] > 0)
    {
        [spaceString appendString:space];
        [spaceString appendString:@" "];
        s = space;
    }
    
    [string appendString:[NSString stringWithFormat:@"%@{\n", s]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSDictionary class]])
         {
             NSString *objString = [self stringFromDictionary:obj composeSpace:spaceString];
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : %@", spaceString, key, objString]];
         }
         else if ([obj isKindOfClass:[NSArray class]])
         {
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : [", spaceString, key]];
             
             [obj enumerateObjectsUsingBlock:^(id objt, NSUInteger idx, BOOL *stop)
              {
                  if ([objt isKindOfClass:[NSDictionary class]])
                  {
                      NSString *objString = [self stringFromDictionary:objt composeSpace:spaceString];
                      [string appendString:[NSString stringWithFormat:@"%@", objString]];
                  }
              }];
             
             [string appendString:[NSString stringWithFormat:@"%@]\n", spaceString]];
         }
         else if ([obj isKindOfClass:[NSString class]])
         {
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : \"%@\"\n", spaceString, key, obj]];
         }
     }];
    [spaceString deleteCharactersInRange:NSMakeRange(0, 2)];
    [string appendString:[NSString stringWithFormat:@"%@}\n", spaceString]];
    return string;
}

@end
