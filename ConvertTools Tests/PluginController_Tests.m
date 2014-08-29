//
//  PluginController_Tests.m
//  ConvertTools
//
//  Created by maxfong on 14-7-16.
//
//

#import <XCTest/XCTest.h>
#import "MAXPluginController.h"
#import "MAXJSONDictionaryController.h"

@interface PluginController_Tests : XCTestCase

@property (nonatomic, strong) MAXPluginController *controller;

@end

@implementation PluginController_Tests

- (void)setUp
{
    [super setUp];
    self.controller = MAXPluginController.new;
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

- (void)testCheckJSON
{
    NSString *json = @"{\"a\":\"a\",\"b\":\"b\",\"c\":{\"a\":\"a\"),\"b\":\"b\",\"c\":\"c\"}}";
    NSError *error = [MAXJSONDictionaryController checkJSON:json];
    
    NSString * errMsg = [MAXJSONDictionaryController jsonSpecificError:error originString:json];
    NSLog(@"%@", errMsg);
    
    NSAssert(!error, error.description);
}

- (void)testFormatterPrint
{
    NSString *json = @"{\"d\":[{\"q\":\"d\",\"b\":\"d\"},{\"q\":\"d\",\"b\":\"d\"},{\"q\":\"d\",\"b\":\"d\"}]}";
    
    NSDictionary *dic = [MAXJSONDictionaryController json2Dictionary:json error:nil];
    
    NSString *string = [MAXJSONDictionaryController formatDictionary:dic composeSpace:nil];
    
    NSLog(@"%@", string);
}

- (void)testpressedCheckJSON
{
    [self.controller didPressedCheckJSON:nil];
}

@end
