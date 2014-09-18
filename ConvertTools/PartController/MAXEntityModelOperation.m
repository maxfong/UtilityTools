//
//  MAXEntityModelOperation.m
//  ConvertTools
//
//  Created by maxfong on 14-9-17.
//
//

#import "MAXEntityModelOperation.h"

@implementation MAXEntityModelOperation

+ (BOOL)createEntityFileWithDictionary:(NSDictionary *)dictionary model:(MAXFileEntityModel)model directory:(MAXSearchPathDirectory)directory options:(NSDictionary *)options error:(NSError **)error
{
    BOOL created = [MAXEntityModelCreate createDirectory:directory error:error];
    if (created)
    {
        NSData *contentData = nil;
        NSString *filePath = nil;
        if (model == MAXHeadAndComplieEntity)
        {
            contentData = [MAXEntityModelCreate contentWithModel:MAXHeadEntity originalData:dictionary options:options];
            filePath = [MAXEntityModelCreate filePathWithModel:MAXHeadEntity options:options];
            [MAXEntityModelCreate createFileAtPath:filePath contentData:contentData attributes:nil];
            
            contentData = [MAXEntityModelCreate contentWithModel:MAXComplieEntity originalData:dictionary options:options];
            filePath = [MAXEntityModelCreate filePathWithModel:MAXComplieEntity options:options];
            [MAXEntityModelCreate createFileAtPath:filePath contentData:contentData attributes:nil];
        }
        else
        {
            contentData = [MAXEntityModelCreate contentWithModel:model originalData:dictionary options:options];
            filePath = [MAXEntityModelCreate filePathWithModel:model options:options];
            [MAXEntityModelCreate createFileAtPath:filePath contentData:contentData attributes:nil];
        }
    }
    return created;
}

@end
