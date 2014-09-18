//
//  PluginController_Tests.m
//  ConvertTools
//
//  Created by maxfong on 14-7-16.
//
//

#import <XCTest/XCTest.h>
#import "MAXPluginController.h"
#import "MAXJSONDictionary.h"

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
    NSString *json = @"{\"a\":\"a\",\"b\":\"b\",\"c\":{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}}";
    
    NSError *error = nil;
    [MAXJSONDictionary validityJSONString:json error:&error];
    
    NSString * errMsg = [MAXJSONDictionary JSONSpecificFromError:error originString:json];
    NSLog(@"%@", errMsg);
    
    NSAssert(!error, error.description);
}

- (void)testFormatterPrint
{
    NSString *json = @"{\"a\":\"a\",\"b\":\"b\",\"c\":{\"a\":\"a\",\"b\":\"b\",\"c\":\"c\"}}";
    
    NSError *error = nil;
    NSDictionary *dic = [MAXJSONDictionary dictionaryWithJSONString:json error:&error];
    
    NSString *string = [MAXJSONDictionary stringWithDictionary:dic];
    
    NSString *string1 = [MAXJSONDictionary compressJSONString:string];
    
    NSDictionary *dic1 = [MAXJSONDictionary dictionaryWithJSONString:string1 error:&error];
    NSLog(@"%@", dic1);
    
    NSLog(@"%@", string);
}

- (void)testpressedCheckJSON
{
    [self.controller didPressedCheckJSON:nil];
}


@end
