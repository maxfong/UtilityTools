//
//  MAXPluginController.m
//  ConvertUnicode
//
//  Created by maxfong on 14-7-15.
//
//

#import "MAXPluginController.h"

@implementation MAXPluginController

-(void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)didPressedConvertChinese:sender
{
    NSString *input = txtInput.stringValue;
    NSString *convertedString = [input mutableCopy];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((CFMutableStringRef)convertedString, NULL, transform, YES);
    [txtOutput setStringValue:convertedString];
}

- (IBAction)didPressedAlert:sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"更多想法请联系maxfong"];
    [alert runModal];
}

- (IBAction)didPressedCheckJSON:sender
{
    NSString *outputString = txtJSONInput.stringValue;
    
    NSError *error = [self checkJSON:outputString];
    if (error)
    {
        NSString *errorMsg = [self jsonError:error originString:outputString];
        NSString *message = [NSString stringWithFormat:@"%@\n具体错误在：%@", [self jsonDebugDescription:error], errorMsg];
        NSString *messageText = @"验证 JSON 时出现错误";
        
        NSAlert *alert = [NSAlert alertWithMessageText:messageText defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:message, nil];
        [alert runModal];
    }
    else
    {
        NSDictionary *dic = [self json2Dictionary:outputString error:nil];
        [txtJSONInput setStringValue:[self composeDictionary:dic composeSpace:nil]];
    }
}

- (IBAction)didPressedFileCreate:sender
{
    
}

#pragma mark - method
- (NSDictionary *)json2Dictionary:(NSString *)jsonString error:(NSError **)error
{
    if ([jsonString length] > 0)
    {
        NSData *data = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:error];
        return dic;
    }
    return nil;
}

- (NSError *)checkJSON:(NSString *)jsonString
{
    NSError *error = nil;
    [self json2Dictionary:jsonString error:&error];
    return error;
}

- (NSString *)jsonDebugDescription:(NSError *)error
{
    return [error.userInfo valueForKey:@"NSDebugDescription"];
}

- (NSString *)jsonError:(NSError *)error originString:(NSString *)originString
{
    if (error)
    {
        NSString *string = [self jsonDebugDescription:error];
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

- (NSString *)composeDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space
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
             NSString *objString = [self composeDictionary:obj composeSpace:spaceString];
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : %@", spaceString, key, objString]];
         }
         else if ([obj isKindOfClass:[NSArray class]])
         {
             [string appendString:[NSString stringWithFormat:@"%@\"%@\" : [", spaceString, key]];
             
             [obj enumerateObjectsUsingBlock:^(id objt, NSUInteger idx, BOOL *stop)
             {
                 if ([objt isKindOfClass:[NSDictionary class]])
                 {
                     NSString *objString = [self composeDictionary:objt composeSpace:spaceString];
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

- (NSUInteger)stringRepeatCount:(NSString *)originString repeatString:(NSString *)repeatString
{
    NSUInteger cnt = 0, length = [originString length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [originString rangeOfString:repeatString options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++; 
        }
    }
    return cnt;
}

@end
