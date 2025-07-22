//
//  ZDBleToolTests.m
//  ZDBleToolTests
//
//  Created by 徐伟新 on 2025/6/24.
//

#import <XCTest/XCTest.h>

@interface ZDBleToolTests : XCTestCase

@end

@implementation ZDBleToolTests

- (void)setUp {
    [super setUp];
    // 在每个测试方法之前调用
}

- (void)tearDown {
    // 在每个测试方法之后调用
    [super tearDown];
}

#pragma mark - 基础测试

- (void)testExample {
    // 这是一个基础的功能测试示例
    XCTAssertTrue(YES, @"基础测试通过");
}

- (void)testPerformanceExample {
    // 这是一个性能测试示例
    [self measureBlock:^{
        // 在这里放置要测量时间的代码
        for (int i = 0; i < 1000; i++) {
            NSString *testString = [NSString stringWithFormat:@"test_%d", i];
            [testString length];
        }
    }];
}

@end
