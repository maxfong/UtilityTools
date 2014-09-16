//
//  MAXRequestController.m
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import "MAXRequestController.h"
#import "MAXProtocolEngine.h"
#import "NSString+UnicodeConvert.h"
#import "MAXJSONDictionaryController.h"
#import "MAXEntityOperationController.h"

@interface MAXRequestController ()

@end

@implementation MAXRequestController


#pragma mark - IBAction
- (IBAction)didPressedSubmitRequest:sender
{
    NSError *error;
    NSString *requestString = [self requestStringWithError:&error];
    
    if (requestString)
    {
        [self formatterWithTextbox:txtvResponseOutput content:requestString];
    }
    else
    {
        [txtvResponseOutput setString:[error description]];
    }
}

- (IBAction)didPressedFormatterRequest:sender
{
    [self formatterWithTextbox:txtvRequestInput content:[self requestString]];
}

- (IBAction)didPressedFormatterResponse:sender
{
    [self formatterWithTextbox:txtvResponseOutput content:[self responseString]];
}

- (IBAction)didPressedCreateRequestFile:sender
{
    NSError *error;
    NSString *requestString = [self requestString];
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:requestString error:&error];
    if (dictionary)
    {
        NSMutableDictionary *requestDictionary = [dictionary[@"request"][@"body"] mutableCopy];
        [requestDictionary removeObjectForKey:@"clientInfo"];
        [self createEntityWithDictionary:requestDictionary
                                   model:TCTRequestEntity];
    }
}

- (IBAction)didPressedCreateResponseFile:sender
{
    NSError *error = nil;
    NSString *responseString = [self responseString];
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:responseString error:&error];
    if (dictionary)
    {
        [self createEntityWithDictionary:dictionary[@"response"][@"body"]
                                   model:TCTResponseEntity];
    }
}

- (IBAction)didPressedCreateFileSaveDesktop:sender
{
    NSString *string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", [MAXJSONDictionaryController compressJSONString:[self requestString]], [MAXJSONDictionaryController compressJSONString:[[self url] description]], [MAXJSONDictionaryController compressJSONString:[self responseString]]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData *contentData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    int identifier = (arc4random() % 9527) + 1;
    NSString *filePath = [NSString stringWithFormat:@"/Users/%@/Desktop/%d.txt", NSUserName(), identifier];
    
    [manager createFileAtPath:filePath contents:contentData attributes:nil];
}

#pragma mark - Private
- (NSString *)urlString
{
    return txtfInterfaceURL.stringValue ?: nil;
}
- (NSURL *)url
{
    NSString *urlString = [self urlString];
    return [NSURL URLWithString:urlString];
}

- (NSString *)serverName
{
    return txtfServerName.stringValue ?: nil;
}

- (NSString *)requestString
{
    return txtvRequestInput.string ?: @"";
}

- (NSString *)responseString
{
    return txtvResponseOutput.string ?: @"";
}

- (NSDictionary *)optionsDictionary
{
    NSString *serverName = [self serverName] ?: @"Test";
    
    NSArray *separateArrar = @[@"leapi/", @"0/", @"8/", @"sbook", @"ation"];
    __block NSString *interface = @"";
    NSString *urlString = [[self urlString] lowercaseString] ?: nil;
    [separateArrar enumerateObjectsUsingBlock:^(NSString *value, NSUInteger idx, BOOL *stop)
    {
        NSArray *tmpArray = [urlString componentsSeparatedByString:value];
        if ([tmpArray count] > 1)
        {
            interface = [tmpArray lastObject];
            *stop = YES;
        }
    }];
    
    return @{TCTModelFileServerNameKey: serverName,
             TCTModelFileInterfaceKey : interface};
}

- (NSString *)requestStringWithError:(NSError **)error
{
    return [MAXProtocolEngine postRequestWithURL:[self url]
                                      JSONString:[self requestString]
                                           error:error] ?: @"";
}

- (BOOL)formatterWithTextbox:(id)textBox content:(NSString *)content
{
    if ([textBox isKindOfClass:[NSTextView class]])
    {
        NSError *error;
        NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:content error:&error];
        if (error)
        {
            [textBox setString:content];
        }
        else
        {
            [textBox setString:[[MAXJSONDictionaryController stringWithDictionary:dictionary] chineseFromUnicode]];
        }
        return YES;
    }
    return NO;
}

- (void)createEntityWithDictionary:(NSDictionary *)dictionary model:(TCTFileEntityModel)model
{
    if ([[self serverName] length] > 0 && dictionary)
    {
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary
                                                               model:model
                                                           directory:TCTUserDesktopDirectory
                                                             options:[self optionsDictionary]
                                                               error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
    else
    {
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"请输入服务名(文件名)...", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

@end
