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
    BOOL hasIntValue = [self validityIntValueWithJSONString:jsonString error:error];
    if (hasIntValue)
    {
        return nil;
    }
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
    BOOL hasIntValue = [self validityIntValueWithJSONString:jsonString error:error];
    if (hasIntValue)
    {
        return NO;
    }
    NSDictionary *dictionary = [self dictionaryWithJSONString:jsonString error:error];
    return (dictionary ? YES : NO);
}

+ (BOOL)validityIntValueWithJSONString:(NSString *)jsonString error:(NSError **)error
{
    NSString *regex = @"\"\\s?:\\s?[0-9]";
    NSRange regexRange = [jsonString rangeOfString:regex options:NSRegularExpressionSearch];
    if (regexRange.location != NSNotFound)
    {
        NSString *description = [NSString stringWithFormat:@"No value for key in object around character %lu.", (unsigned long)regexRange.location];
        if (error)
        {
            *error = [NSError errorWithDomain:@"" code:0 userInfo:@{@"NSDebugDescription": description}];
        }
        
        return YES;
    }
    return NO;
}

+ (NSString *)JSONDescriptionWithError:(NSError *)error
{
    return [error.userInfo valueForKey:@"NSDebugDescription"];
}

+ (NSString *)JSONSpecificFromError:(NSError *)error originString:(NSString *)originString
{
    NSError *err = nil;
    NSString *JSONString = [self compressJSONString:originString];
    if (error)
    {
        err = error;
    }
    else
    {
        [self dictionaryWithJSONString:JSONString error:&err];
    }
    if (err)
    {
        NSString *string = [self JSONDescriptionWithError:err];
        NSArray *array = [string componentsSeparatedByString:@" "];
        if ([array count] > 0)
        {
            NSString *s = [[array lastObject] substringToIndex:[[array lastObject] length] - 1];
            
            if ([s intValue] > 0)
            {
                NSInteger maxCount = [JSONString length];
                NSInteger errLocation = [s intValue];
                
                NSInteger maxLength = 20;
                while (maxLength + errLocation > maxCount)
                {
                    maxLength -= 1;
                }
                
                NSInteger mixLocation = errLocation - 20;
                while (mixLocation <= 0)
                {
                    mixLocation += 1;
                }
                
                NSRange range = NSMakeRange(mixLocation, ((errLocation - mixLocation) + maxLength));
                NSMutableString *message = [[JSONString substringWithRange:range] mutableCopy];
                
                [message appendString:@"\n"];
                for (int i = 0; i < (errLocation - mixLocation+3); i++)
                {
                    [message appendString:@" "];
                }
                [message appendString:@"^"];
                return message;
            }
            else
            {
                return string;
            }
        }
    }
    return nil;
}

+ (NSString *)compressJSONString:(NSString *)JSONString
{
    NSArray *array = @[@" "];
    
    __block NSString *resultString = JSONString;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        resultString = [resultString stringByReplacingOccurrencesOfString:obj withString:@""];
    }];
    resultString = [resultString stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    
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
             while (regexRange.location != NSNotFound)
             {
                 NSRange range = {regexRange.location, 2};
                 objString = [objString stringByReplacingCharactersInRange:range withString:@"\""];
                 regexRange = [objString rangeOfString:regex options:NSRegularExpressionSearch];
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
                      while (regexRange.location != NSNotFound)
                      {
                          NSRange range = {regexRange.location, 2};
                          objString = [objString stringByReplacingCharactersInRange:range withString:@"\""];
                          regexRange = [objString rangeOfString:regex options:NSRegularExpressionSearch];
                      }
                      
                      [string appendString:[NSString stringWithFormat:@"%@", objString]];
                      NSRange range = {string.length - 2 , 2};
                      [string replaceCharactersInRange:range withString:@"},\r"];
                  }
              }];
             [string appendString:[NSString stringWithFormat:@"%@],\r", spaceString]];
             
             NSString *regex = @"\\}\\,\\r\\s*]";
             NSRange regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
             while (regexRange.location != NSNotFound)
             {
                 NSRange range = {regexRange.location, 2};
                 [string replaceCharactersInRange:range withString:@"}"];
                 regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
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
    while (regexRange.location != NSNotFound)
    {
        NSRange range = {regexRange.location, 2};
        [string replaceCharactersInRange:range withString:@"]"];
        regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
    }
    
    [@[@"}", @"]"] enumerateObjectsUsingBlock:^(NSString *sign, NSUInteger idx, BOOL *stop)
    {
        NSString *regex = [NSString stringWithFormat:@"\\%@\\r\\s*\\\"\\w*\\\"\\s*:", sign];
        NSRange regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
        
        while (regexRange.location != NSNotFound)
        {
            NSRange range = {regexRange.location, 2};
            NSString *replaceString = [NSString stringWithFormat:@"%@,\r", sign];
            [string replaceCharactersInRange:range withString:replaceString];
            regexRange = [string rangeOfString:regex options:NSRegularExpressionSearch];
        }
    }];
    
    return string;
}

@end
