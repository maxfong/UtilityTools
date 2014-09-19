//
//  MAXProtocolEngine.h
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import <Foundation/Foundation.h>

@interface MAXProtocolEngine : NSObject

+ (void)postRequestWithURL:(NSURL *)url JSONString:(NSString *)JSONString completionHandler:(void (^)(NSString *, NSError*)) handler;

+ (BOOL)validityJSONString:(NSString *)JSONString error:(NSError **)error;

@end
