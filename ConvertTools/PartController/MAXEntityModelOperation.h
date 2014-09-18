//
//  MAXEntityModelOperation.h
//  ConvertTools
//
//  Created by maxfong on 14-9-17.
//
//

#import <Foundation/Foundation.h>
#import "MAXEntityModelCreate.h"

@interface MAXEntityModelOperation : NSObject

+ (BOOL)createEntityFileWithDictionary:(NSDictionary *)dictionary
                                 model:(MAXFileEntityModel)model
                             directory:(MAXSearchPathDirectory)directory
                               options:(NSDictionary *)options
                                 error:(NSError **)error;

@end
