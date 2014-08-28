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
    [alert runModal];
}

- (IBAction)didPressedCheckJSON:sender
{
    NSString *outputString = txtvConsole.string ?: @"";
    
    NSError *error = [MAXJSONDictionaryController checkJSON:outputString];
    if (error)
    {
        NSString *errorMsg = [MAXJSONDictionaryController jsonSpecificError:error originString:outputString];
        NSString *message = [NSString stringWithFormat:@"%@\n具体错误在：%@", [MAXJSONDictionaryController jsonErrorDescription:error], errorMsg];
        NSString *messageText = @"验证 JSON 时出现错误";
        
        NSAlert *alert = [NSAlert alertWithMessageText:messageText defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:message, nil];
        [alert runModal];
    }
    else
    {
        NSDictionary *dic = [MAXJSONDictionaryController json2Dictionary:outputString error:nil];
        [txtvConsole setString:[[dic description] chineseFromUnicode]];
    }
}

- (IBAction)didPressedFileCreate:sender
{
    
}

@end
