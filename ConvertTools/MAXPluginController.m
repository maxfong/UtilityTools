//
//  MAXPluginController.m
//  ConvertUnicode
//
//  Created by maxfong on 14-7-15.
//
//

#import "MAXPluginController.h"
#import "NSString+UnicodeConvert.h"
#import "MAXJSONDictionary.h"
#import "MAXEntityModelOperation.h"

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
    NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@"更多想法请联系maxfong，是否访问项目github？"];
    [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == 1)
    {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://github.com/maxfong/UtilityTools"]];
    }
}

- (IBAction)didPressedCheckJSON:sender
{
    NSString *outputString = txtvConsole.string ?: @"";
    
    BOOL validity = [MAXJSONDictionary validityJSONString:outputString error:nil];
    if (validity)
    {
        NSDictionary *dictionary = [MAXJSONDictionary dictionaryWithJSONString:outputString error:nil];
        [txtvConsole setString:[[MAXJSONDictionary stringWithDictionary:dictionary] chineseFromUnicode]];
    }
    else
    {
        NSString *errorMsg = [MAXJSONDictionary JSONSpecificFromError:nil originString:outputString];
        if ([errorMsg length] > 0)
        {
            [txtfConsole setStringValue:errorMsg];
            return;
        }
    }
    [txtfConsole setStringValue:@"验证通过"];
}

- (IBAction)didPressedFileCreate:sender
{
    NSString *outputString = txtvConsole.string ?: @"";
    NSError *error;
    NSDictionary *dictionary = [MAXJSONDictionary dictionaryWithJSONString:outputString error:&error];
    if (dictionary)
    {
        [MAXEntityModelOperation createEntityFileWithDictionary:dictionary
                                                          model:MAXHeadAndComplieEntity
                                                      directory:MAXUserDesktopDirectory
                                                        options:@{MAXModelFileServerNameKey : @"MAXTDemo"}
                                                          error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:@"提示" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"生成成功！", nil];
        [alert beginSheetModalForWindow:nil modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
}

@end
