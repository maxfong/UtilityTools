//
//  MAXJSONDictionary.m
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import "MAXJSONDictionary.h"

@implementation MAXJSONDictionary

+ (NSDictionary *)dictionaryWithJSONString:(NSString *)jsonString error:(NSError **)error
{
    NSString *replaceString = [self compressJSONString:jsonString];
    NSData *JSONData = [replaceString dataUsingEncoding:NSUnicodeStringEncoding];
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
    if (error && [originString length] > 0)
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

+ (NSString *)compressJSONString:(NSString *)JSONString
{
    NSArray *array = @[@"\r", @"\n", @" "];
    
    __block NSString *resultString = JSONString;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:obj withString:@""];
    }];
    
    return resultString;
}

+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary
{
    return [self stringWithDictionary:dictionary composeSpace:nil];
}

+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space
{
    NSMutableString *string = [NSMutableString string];
    
    NSMutableString *spaceString = [NSMutableString stringWithString:@"  "];
    NSString *s = @"";
    if ([space length] > 0)
    {
        [spaceString appendString:space];
        s = space;
    }
    
    [string appendString:[NSString stringWithFormat:@"%@{\r", s]];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
     {
         if ([obj isKindOfClass:[NSDictionary class]])
         {
             NSString *objString = [self stringWithDictionary:obj composeSpace:spaceString];
             
             NSString *regex = @"\",\\r\\s*\\}\\r";
             NSRange regexRange = [objString rangeOfString:regex options:NSRegularExpressionSearch];
             if (regexRange.location != NSNotFound)
             {
                 NSRange range = {regexRange.location, 2};
                 objString = [objString stringByReplacingCharactersInRange:range withString:@"\""];
             }
             
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : %@", spaceString, key, objString]];
         }
         else if ([obj isKindOfClass:[NSArray class]])
         {
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : [", spaceString, key]];
             
             [obj enumerateObjectsUsingBlock:^(id objt, NSUInteger idx, BOOL *stop)
              {
                  if ([objt isKindOfClass:[NSDictionary class]])
                  {
                      NSString *objString = [self stringWithDictionary:objt composeSpace:spaceString];
                      NSString *regex = @"\",\\r\\s*\\}\\r";
                      NSRange regexRange = [objString rangeOfString:regex options:NSRegularExpressionSearch];
                      if (regexRange.location != NSNotFound)
                      {
                          NSRange range = {regexRange.location, 2};
                          objString = [objString stringByReplacingCharactersInRange:range withString:@"\""];
                      }
                      
                      [string appendString:[NSString stringWithFormat:@"%@", objString]];
                      NSRange range = {string.length - 2 , 2};
                      [string replaceCharactersInRange:range withString:@"},\r"];
                  }
              }];
             [string appendString:[NSString stringWithFormat:@"%@],\r", spaceString]];
             
             NSString *regex = @"\\}\\,\\r\\s*]";
             NSRange regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
             if (regexRange.location != NSNotFound)
             {
                 NSRange range = {regexRange.location, 2};
                 [string replaceCharactersInRange:range withString:@"}"];
             }
         }
         else if ([obj isKindOfClass:[NSString class]])
         {
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : \"%@\",\r", spaceString, key, obj]];
         }
     }];
    [spaceString deleteCharactersInRange:NSMakeRange(0, 2)];
    [string appendString:[NSString stringWithFormat:@"%@}\r", spaceString]];
    
    NSString *regex = @"\\],\\r\\s*\\}\\r";
    NSRange regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
    if (regexRange.location != NSNotFound)
    {
        NSRange range = {regexRange.location, 2};
        [string replaceCharactersInRange:range withString:@"]"];
    }
    
    [@[@"}", @"]"] enumerateObjectsUsingBlock:^(NSString *sign, NSUInteger idx, BOOL *stop)
    {
        NSString *regex = [NSString stringWithFormat:@"\\%@\\r\\s*\\\"\\w*\\\"\\s*:", sign];
        NSRange regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
        if (regexRange.location != NSNotFound)
        {
            NSRange range = {regexRange.location, 2};
            NSString *replaceString = [NSString stringWithFormat:@"%@,\r", sign];
            [string replaceCharactersInRange:range withString:replaceString];
        }
    }];
    
    return string;
}

@end
