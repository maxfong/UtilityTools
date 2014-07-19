//
//  MAXPluginController.h
//  ConvertUnicode
//
//  Created by maxfong on 14-7-15.
//
//

#import <Cocoa/Cocoa.h>
#import "NSTextField+copypaste.h"

@interface MAXPluginController : NSWindowController
{
    IBOutlet NSTextField *txtInput, *txtOutput;
    IBOutlet NSScrollView *scrollViewOutput;
    IBOutlet NSTextField *txtJSONInput;
}

- (IBAction)didPressedConvertChinese:sender;    //Unicode转换
- (IBAction)didPressedAlert:sender;             //关于
- (IBAction)didPressedCheckJSON:sender;         //验证
- (IBAction)didPressedFileCreate:sender;        //生成

- (NSError *)checkJSON:(NSString *)string;
- (NSDictionary *)json2Dictionary:(NSString *)jsonString error:(NSError **)error;
- (NSString *)jsonError:(NSError *)error originString:(NSString *)originString;
- (NSUInteger)stringRepeatCount:(NSString *)originString repeatString:(NSString *)repeatString;
- (NSString *)composeDictionary:(NSDictionary *)dictionary composeSpace:(NSString *)space;

@end

