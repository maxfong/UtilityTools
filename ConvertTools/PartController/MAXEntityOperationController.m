//
//  MAXEntityOperationController.m
//  ConvertTools
//
//  Created by maxfong on 14-9-14.
//
//

#import "MAXEntityOperationController.h"

@implementation MAXEntityOperationController

+ (BOOL)createEntityFileWithDictionary:(NSDictionary *)dictionary model:(TCTFileEntityModel)model directory:(TCTSearchPathDirectory)directory options:(NSDictionary *)options error:(NSError **)error
{
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *fileSaveDirectory = [self saveFileDirectory];
    if (![manager createDirectoryAtPath:fileSaveDirectory withIntermediateDirectories:YES attributes:nil error:error])
    {
        return NO;
    }
    
    if (model == TCTRequestEntity || model == TCTResponseEntity)
    {
        for (int i = 1; i < 3; i++)
        {
            //读出来后再改->替换响应的符号
            NSData *contentData = [self contentWithModel:(model - i) originalData:dictionary options:options];
            
            //准备创建文件，通过数据获取服务名，创建名称
            NSString *filePath = [self filePathWithModel:(model - i) options:options];
            [manager createFileAtPath:filePath contents:contentData attributes:nil];
        }
    }
    else
    {
        //读出来后再改->替换响应的符号
        NSData *contentData = [self contentWithModel:model originalData:dictionary options:options];
        
        //准备创建文件，通过数据获取服务名，创建名称
        NSString *filePath = [self filePathWithModel:model options:options];
        [manager createFileAtPath:filePath contents:contentData attributes:nil];
    }
    return NO;
}

+ (NSData *)contentWithModel:(TCTFileEntityModel)model originalData:(NSDictionary *)dictionary options:(NSDictionary *)options
{
    NSString *modelContent = [self stringWithMode:model];
    //替换数据
    NSString *replaceString = [MAXEntityModelReplace replaceStringWithString:modelContent object:dictionary fileModel:model options:options];
    
    return [replaceString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)stringWithMode:(TCTFileEntityModel)model
{
    NSString *modelFilePath = [self modelFilePathWithModel:model];
    return [NSString stringWithContentsOfFile:modelFilePath encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString *)saveFileDirectory
{
    return [NSString stringWithFormat:@"/Users/%@/Desktop/TCTEntityFiles", NSUserName()];
}

+ (NSString *)modelFilePathWithModel:(TCTFileEntityModel)model
{
    NSString *modelName = [self modelNameWithModel:model];
    //TODO:resources path
    return [NSString stringWithFormat:@"/Users/%@/Library/Application Support/Developer/Shared/Xcode/Plug-ins/UtilityTools.xcplugin/Contents/Resources/%@", NSUserName(), modelName];
}

//通过服务名和模型确定文件名称和路径
+ (NSString *)filePathWithModel:(TCTFileEntityModel)model options:(NSDictionary *)options
{
    NSString *saveFileDirectory = [self saveFileDirectory];
    NSString *fileName = [self fileNameWithModel:model options:options];
    return [NSString stringWithFormat:@"%@/%@", saveFileDirectory, fileName];
}

+ (NSString *)modelNameWithModel:(TCTFileEntityModel)model
{
    NSString *modelName = nil;
    switch (model)
    {
        case TCTRequestHeadEntity:
            modelName = @"TCTEntityFilesRequestModel.h.model";
            break;
        case TCTRequestComplieEntity:
            modelName = @"TCTEntityFilesRequestModel.m.model";
            break;
        case TCTResponseHeadEntity:
            modelName = @"TCTEntityFilesResponseModel.h.model";
            break;
        case TCTResponseComplieEntity:
            modelName = @"TCTEntityFilesResponseModel.m.model";
            break;
        default:
            modelName = @"unknown";
            break;
    }
    return modelName;
}
+ (NSString *)fileNameWithModel:(TCTFileEntityModel)model options:(NSDictionary *)options
{
    NSString *fileName = nil;
    
    switch (model)
    {
        case TCTRequestHeadEntity:
            fileName = [NSString stringWithFormat:@"Request%@.h", options[TCTModelFileServerNameKey]];
            break;
        case TCTRequestComplieEntity:
            fileName = [NSString stringWithFormat:@"Request%@.m", options[TCTModelFileServerNameKey]];
            break;
        case TCTResponseHeadEntity:
            fileName = [NSString stringWithFormat:@"Response%@.h", options[TCTModelFileServerNameKey]];
            break;
        case TCTResponseComplieEntity:
            fileName = [NSString stringWithFormat:@"Response%@.m", options[TCTModelFileServerNameKey]];
            break;
        default:
            fileName = @"unknown";
            break;
    }
    return fileName;
}


@end
