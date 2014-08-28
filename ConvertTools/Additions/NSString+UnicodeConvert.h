//
//  NSString+UnicodeConvert.h
//  ConvertTools
//
//  Created by maxfong on 14-8-28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (UnicodeConvert)

- (NSString *)chineseFromUnicode;
- (NSUInteger)repeatCountWithString:(NSString *)repeatString;

@end
