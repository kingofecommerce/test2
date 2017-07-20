//
//  IOSChallengeJiahnUITests.m
//  IOSChallengeJiahnUITests
//
//  Created by jiahn on 7/19/17.
//  Copyright © 2017 jiahn. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OfferWallTableViewController.h"

@interface IOSChallengeJiahnUITests : XCTestCase

@end

@implementation IOSChallengeJiahnUITests

- (void)setUp {
    [super setUp];
    
    //대략의 유닛 테스트 시나리오는 네트웍 관련 클래스를 만들어서 그것이 이상이 잇는지 없는지에 대해서 검증
    //OfferWallTableViewController *offerWallTableViewController;

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

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
