//
//  DropMenuDemoUITests.m
//  DropMenuDemoUITests
//
//  Created by GeWei on 2017/1/17.
//  Copyright © 2017年 GeWei. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AHDropMenuView.h"
@interface DropMenuDemoUITests : XCTestCase

@end

@implementation DropMenuDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithNavigationController:(UINavigationController *)navigationController withDelegate:(id<AHDropMenuViewDelegate>)delegate {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.tables.staticTexts[@"5.CLIPPERS"] swipeDown];
    [app.navigationBars[@"Drop"].buttons[@"Drop"] tap];
    [[[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"Drop"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];
    
}


- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
