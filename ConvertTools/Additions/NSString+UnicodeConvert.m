//
//  NSString+UnicodeConvert.m
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import "NSString+UnicodeConvert.h"

@implementation NSString (UnicodeConvert)

- (NSString *)chineseFromUnicode
{
    NSString *convertedString = [[self mutableCopy] stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}

- (NSUInteger)repeatCountWithString:(NSString *)repeatString
{
    NSUInteger cnt = 0, length = [self length];
    NSRange range = NSMakeRange(0, length);
    while(range.location != NSNotFound)
    {
        range = [self rangeOfString:repeatString options:0 range:range];
        if(range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            cnt++;
        }
    }
    return cnt;
}

@end
