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
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary[@"request"][@"body"]
                                                               model:TCTRequestEntity
                                                           directory:TCTUserDesktopDirectory
                                                               error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

- (IBAction)didPressedCreateResponseFile:sender
{
    NSError *error = nil;
    NSString *responseString = [self responseString];
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:responseString error:&error];
    if (dictionary)
    {
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary[@"response"][@"body"]
                                                               model:TCTResponseEntity
                                                           directory:TCTUserDesktopDirectory
                                                               error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
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
- (NSURL *)url
{
    NSString *urlString = txtfInterfaceURL.stringValue ?: nil;
    return [NSURL URLWithString:urlString];
}

- (NSString *)requestString
{
    return txtvRequestInput.string ?: @"";
}

- (NSString *)responseString
{
    return txtvResponseOutput.string ?: @"";
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

@end
