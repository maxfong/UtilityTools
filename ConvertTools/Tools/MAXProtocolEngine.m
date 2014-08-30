//
//  MAXProtocolEngine.m
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import "MAXProtocolEngine.h"
#import "NSString+UnicodeConvert.h"

@implementation MAXProtocolEngine

+ (NSString *)postRequestWithURL:(NSURL *)url JSONString:(NSString *)JSONString error:(NSError **)error
{
    BOOL validity = [self validityJSONString:JSONString error:error];
    if (!validity) {
        return nil;
    }
    
    NSData *HTTPBody = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:HTTPBody];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    
    return (responseData ? [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] : nil);
}

+ (BOOL)validityJSONString:(NSString *)JSONString error:(NSError **)error
{
    NSString *string = JSONString ?: @"";
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:error];
    
    return (JSONDictionary ? YES : NO);
}

@end
