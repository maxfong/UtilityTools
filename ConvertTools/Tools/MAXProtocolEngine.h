//
//  MAXProtocolEngine.h
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import <Foundation/Foundation.h>

@interface MAXProtocolEngine : NSObject

+ (NSString *)postRequestWithURL:(NSURL *)url JSONString:(NSString *)JSONString error:(NSError **)error;
+ (BOOL)validityJSONString:(NSString *)JSONString error:(NSError **)error;

@end
