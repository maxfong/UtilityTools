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
#import "MAXJSONDictionary.h"
#import "MAXEntityModelOperation.h"

@interface MAXRequestController ()

@end

@implementation MAXRequestController


#pragma mark - IBAction
- (IBAction)didPressedSubmitRequest:sender
{
    NSError *error;
    NSString *requestString = [self requestStringWithError:&error];
    
    if ([requestString length] > 0)
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
    NSDictionary *dictionary = [MAXJSONDictionary dictionaryWithJSONString:requestString error:&error];
    if (dictionary)
    {
        NSMutableDictionary *requestDictionary = [dictionary[@"request"][@"body"] mutableCopy];
        [requestDictionary removeObjectForKey:@"clientInfo"];
        [self createEntityWithDictionary:requestDictionary
                                   model:MAXHeadAndComplieEntity
                                  prefix:@"Request"
                              superClass:@"RequestSuperObj"];
    }
}

- (IBAction)didPressedCreateResponseFile:sender
{
    NSError *error = nil;
    NSString *responseString = [self responseString];
    NSDictionary *dictionary = [MAXJSONDictionary dictionaryWithJSONString:responseString error:&error];
    if (dictionary)
    {
        [self createEntityWithDictionary:dictionary[@"response"][@"body"]
                                   model:MAXHeadAndComplieEntity
                                  prefix:@"Response"
                              superClass:@"NSObject"];
    }
}

- (IBAction)didPressedCreateFileSaveDesktop:sender
{
    NSString *string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", [MAXJSONDictionary compressJSONString:[self requestString]], [MAXJSONDictionary compressJSONString:[[self url] description]], [MAXJSONDictionary compressJSONString:[self responseString]]];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSData *contentData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    int identifier = (arc4random() % 9527) + 1;
    NSString *filePath = [NSString stringWithFormat:@"/Users/%@/Desktop/%d.txt", NSUserName(), identifier];
    
    [manager createFileAtPath:filePath contents:contentData attributes:nil];
}

#pragma mark - Private
- (NSString *)urlString
{
    return [txtfInterfaceURL.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""] ?: nil;
}
- (NSURL *)url
{
    NSString *urlString = [self urlString];
    return [NSURL URLWithString:urlString];
}

- (NSString *)serverName
{
    return [txtfServerName.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""] ?: nil;
}

- (NSString *)requestString
{
    return [txtvRequestInput.string stringByReplacingOccurrencesOfString:@" " withString:@""] ?: @"";
}

- (NSString *)responseString
{
    return [txtvResponseOutput.string stringByReplacingOccurrencesOfString:@" " withString:@""] ?: @"";
}

- (NSDictionary *)optionsDictionaryWithPrefix:(NSString *)prefix model:(MAXFileEntityModel)model superClass:(NSString *)superClass
{
    NSMutableDictionary *dictionary = [@{} mutableCopy];

    [dictionary setValue:prefix ?: @"" forKey:MAXModelFilePrefixKey];
    [dictionary setValue:[self serverName] ?: @"Test" forKey:MAXModelFileServerNameKey];
    
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
    [dictionary setValue:interface forKey:MAXModelFileInterfaceKey];
    
    if ([[prefix lowercaseString] isEqualToString:@"response"])
    {
        [dictionary setValue:@"" forKey:MAXModelFileInitKey];
    }
    return dictionary;
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
        NSDictionary *dictionary = [MAXJSONDictionary dictionaryWithJSONString:content error:&error];
        if (error)
        {
            [textBox setString:content];
        }
        else
        {
            [textBox setString:[[MAXJSONDictionary stringWithDictionary:dictionary] chineseFromUnicode]];
        }
        return YES;
    }
    return NO;
}

- (void)createEntityWithDictionary:(NSDictionary *)dictionary model:(MAXFileEntityModel)model prefix:(NSString *)prefix superClass:(NSString *)superClass
{
    if (dictionary)
    {
        [MAXEntityModelOperation createEntityFileWithDictionary:dictionary
                                                          model:model
                                                      directory:MAXUserDesktopDirectory
                                                        options:[self optionsDictionaryWithPrefix:prefix model:model superClass:superClass]
                                                          error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

@end
