//
//  TestsObjc.m
//  YoExt_Tests
//
//  Created by Tony Tong on 1/13/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

#import <XCTest/XCTest.h>
@import YoExt;

@interface TestsObjc : XCTestCase

@end

@implementation TestsObjc

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testGetString {
    NSString *ret = [YoSplit getString];
    XCTAssert([@"YoSplit" isEqualToString:ret]);
}

- (void)testGetClient {
    id<SplitClient> ret = [YoSplit getClient];
    XCTAssertNotNil(ret);
}

@end
