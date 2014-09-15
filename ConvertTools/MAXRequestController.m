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
    NSString *string = txtvRequestInput.string ?: @"";
    [self formatterWithTextbox:txtvRequestInput content:string];
}

- (IBAction)didPressedCreateRequestFile:sender
{
    NSError *error;
    NSString *requestString = [self JSONString];
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:requestString error:&error];
    if (dictionary)
    {
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary[@"request"][@"body"]
                                                               model:TCTRequestEntity
                                                           directory:TCTUserDesktopDirectory
                                                               error:nil];
    }
}

- (IBAction)didPressedCreateResponseFile:sender
{
    NSError *error = nil;
    NSString *responseString = txtvResponseOutput.string ?: @"";
    NSDictionary *dictionary = [MAXJSONDictionaryController dictionaryWithJSONString:responseString error:&error];
    if (dictionary)
    {
        [MAXEntityOperationController createEntityFileWithDictionary:dictionary[@"response"][@"body"]
                                                               model:TCTResponseEntity
                                                           directory:TCTUserDesktopDirectory
                                                               error:nil];
    }
}

#pragma mark - Private
- (NSURL *)url
{
    NSString *urlString = txtfInterfaceURL.stringValue ?: nil;
    return [NSURL URLWithString:urlString];
}

- (NSString *)JSONString
{
    return txtvRequestInput.string ?: @"";
}

- (NSString *)requestStringWithError:(NSError **)error
{
    return [MAXProtocolEngine postRequestWithURL:[self url]
                                      JSONString:[self JSONString]
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
