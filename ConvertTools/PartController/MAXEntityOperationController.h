//
//  MAXEntityOperationController.h
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import <Foundation/Foundation.h>
#import "MAXEntityModelReplace.h"

typedef NS_ENUM(NSUInteger, TCTSearchPathDirectory)
{
    TCTUserDesktopDirectory
};
@interface MAXEntityOperationController : NSObject

+ (BOOL)createEntityFileWithDictionary:(NSDictionary *)dictionary
                                 model:(TCTFileEntityModel)model
                             directory:(TCTSearchPathDirectory)directory
                               options:(NSDictionary *)options
                                 error:(NSError **)error;

@end
