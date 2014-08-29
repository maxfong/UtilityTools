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
    NSString *responseString = [MAXProtocolEngine postRequestWithURL:[self url] parameters:[self parameters] error:&error];
    
    if ([responseString length] > 0)
    {
        NSDictionary *dictionary = [MAXJSONDictionaryController json2Dictionary:responseString error:nil];
        [txtvResponseOutput setString:[[dictionary description] chineseFromUnicode]];
    }
    else
    {
        [txtvResponseOutput setString:[error description]];
    }
}

#pragma mark - Privint
- (NSURL *)url
{
    NSString *urlString = txtfInterfaceURL.stringValue ?: @"";
    return [NSURL URLWithString:urlString];
}

- (NSDictionary *)parameters
{
    return nil;
}

@end
