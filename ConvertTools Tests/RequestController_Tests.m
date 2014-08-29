//
//  RequestController_Tests.m
//  ConvertTools
//
//  Created by maxfong on 14-8-29.
//
//

#import <XCTest/XCTest.h>
#import "MAXProtocolEngine.h"

@interface RequestController_Tests : XCTestCase

@end

@implementation RequestController_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
- (void)testRequest
{
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:@""];
    NSString *jsonString = @"{\"a\":\"b\"}";
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding]; ;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    
    NSString *responseString = [MAXProtocolEngine postRequestWithURL:url parameters:dic error:&error];
    
    NSLog(@"%@", responseString);
}

@end
