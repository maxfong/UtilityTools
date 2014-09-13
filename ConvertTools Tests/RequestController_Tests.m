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
    NSString *jsonString = @"";
    
    NSString *responseString = [MAXProtocolEngine postRequestWithURL:url JSONString:jsonString error:&error];
    
    if (responseString)
    {
        NSLog(@"%@", responseString);
    }
    else
    {
//        error
        
    }
    
}

- (void)testPostRequestWithURL
{
    [MAXProtocolEngine postRequestWithURL:nil JSONString:@"{}" error:nil];
}

- (void)testFileManager
{
    NSFileManager *manager=[NSFileManager defaultManager];
    
    NSString *path = [NSString stringWithFormat:@"/Users/%@/Desktop/TCTEntityFiles", NSUserName()];
    if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
    {
        return NSLog(@"创建目录失败，请重试！");
    }
    
    //移除目录所有文件
    
    
    //创建文件
    NSString *filePath = [NSString stringWithFormat:@"%@/1.h", path];
    [manager createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath]; //以可写方式打开文件
    
    NSString *string = @"1";
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", data);
    
    
    [fileHandle writeData:data]; //写入文件内容
    [fileHandle closeFile];     //关闭文件

}

@end
