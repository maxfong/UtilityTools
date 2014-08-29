//
//  MAXProtocolEngine.m
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import "MAXProtocolEngine.h"

@implementation MAXProtocolEngine

+ (NSString *)postRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters error:(NSError **)error
{
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:parameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    return [self postRequestWithURL:url HTTPBody:bodyData error:error];
}

+ (NSString *)postRequestWithURL:(NSURL *)url HTTPBody:(NSData *)HTTPBody error:(NSError **)error
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:40.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:HTTPBody];
    
    NSURLResponse *response;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
    if (responseData)
    {
        return [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

@end
