//
//  MAXPluginController.m
//  ConvertUnicode
//
//  Created by maxfong on 14-7-15.
//
//

#import "MAXPluginController.h"
#import "NSString+UnicodeConvert.h"
#import "MAXJSONDictionaryController.h"
#import "MAXEntityOperationController.h"

@implementation MAXPluginController

-(void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)didPressedConvertChinese:sender
{
    NSString *input = txtvJSONInput.string ?: @"";
    NSString *convertedString = [input chineseFromUnicode];
    [txtvJSONOutput setString:convertedString];
}

- (IBAction)didPressedAlert:sender
{
    NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"更多想法请联系maxfong"];
    [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)didPressedCheckJSON:sender
{
    NSString *outputString = txtvConsole.string ?: @"";
    
    NSError *error = nil;
    BOOL validity = [MAXJSONDictionaryController validityJSONString:outputString error:&error];
    if (validity)
    {
        NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:outputString error:nil];
        [txtvConsole setString:[[MAXJSONDictionaryController stringWithDictionary:dictionary] chineseFromUnicode]];
    }
    else
    {
        NSString *errorMsg = [MAXJSONDictionaryController JSONSpecificFromError:error originString:outputString];
        NSString *message = [NSString stringWithFormat:@"%@\n具体错误在：%@", [MAXJSONDictionaryController JSONDescriptionWithError:error], errorMsg];
        NSString *messageText = @"验证 JSON 时出现错误";
        
        NSAlert *alert = [NSAlert alertWithMessageText:messageText defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:message, nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

- (IBAction)didPressedFileCreate:sender
{
    NSString *outputString = txtvConsole.string ?: @"";
    NSError *error;
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:outputString error:&error];
    if (dictionary)
    {
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary
                                                               model:TCTResponseEntity
                                                           directory:TCTUserDesktopDirectory
                                                             options:@{TCTModelFileServerNameKey : @"Test"}
                                                               error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

@end
