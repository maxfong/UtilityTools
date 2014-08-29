//
//  MAXProtocolEngine.h
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import <Foundation/Foundation.h>

@interface MAXProtocolEngine : NSObject

+ (NSString *)postRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters error:(NSError **)error;
+ (NSString *)postRequestWithURL:(NSURL *)url HTTPBody:(NSData *)HTTPBody error:(NSError **)error;

@end
