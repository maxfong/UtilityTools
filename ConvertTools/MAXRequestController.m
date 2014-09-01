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

@interface MAXRequestController ()

@end

@implementation MAXRequestController


#pragma mark - IBAction
- (IBAction)didPressedSubmitRequest:sender
{
    NSError *error;
    NSString *responseString = [MAXProtocolEngine postRequestWithURL:[self url]
                                                          JSONString:[self JSONString]
                                                               error:&error];
    
    if (responseString)
    {
        [self formatterWithTextbox:txtvResponseOutput content:responseString];
    }
    else
    {
        [txtvResponseOutput setString:[error description]];
    }
}

- (IBAction)didPressedFormatterRequest:sender
{
    NSString *string = txtvRequestInput.string ?: @"";
    [self formatterWithTextbox:txtvRequestInput content:string];
}

#pragma mark - Private
- (NSURL *)url
{
    NSString *urlString = txtfInterfaceURL.stringValue ?: nil;
    return [NSURL URLWithString:urlString];
}

- (NSString *)JSONString
{
    return txtvRequestInput.string ?: nil;
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
