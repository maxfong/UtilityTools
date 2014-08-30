//
//  NSString+UnicodeConvert.m
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import "NSString+UnicodeConvert.h"
#import<CommonCrypto/CommonDigest.h>

#define CC_MD5_DIGEST_LENGTH    16          /* digest length in bytes */

@implementation NSString (UnicodeConvert)

- (NSString *)chineseFromUnicode
{
    NSString *convertedString = [[self mutableCopy] stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
    
    CFStringRef transform = CFSTR("Any-Hex/Java");
    CFStringTransform((CFMutableStringRef)convertedString, NULL, transform, YES);
    
    return convertedString;
}

- (NSUInteger)repeatCountWithRepeatString:(NSString *)repeatString
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

- (NSString*)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}

@end
