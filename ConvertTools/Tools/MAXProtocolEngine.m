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

+ (void)postRequestWithURL:(NSURL *)url JSONString:(NSString *)JSONString completionHandler:(void (^)(NSString *, NSError*)) handler
{
    NSError *error;
    BOOL validity = [self validityJSONString:JSONString error:&error];
    if (!validity)
    {
        handler (nil, error);
    }
    
    NSData *HTTPBody = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:HTTPBody];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone, NSData *data, NSError *error)
    {
        NSString *responseString = data ? [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] : nil;
        handler(responseString, error);
    }];
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
