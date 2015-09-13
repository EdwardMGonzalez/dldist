//
//  dldistTests.m
//  dldistTests
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSString+dlDistForString.h"


@interface dldistTests : XCTestCase

@end

@implementation dldistTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (int) distanceFromString: (NSString *)base
           toString:(NSString *) comp
             shouldBe:(int) expected {
    int actual = [base dlDistFromString:comp];
    NSLog(@"Actual distance was %d", actual);
    return expected == actual;
}

- (void) testIdenticalStrings {
    XCTAssert([self distanceFromString:@"string" toString:@"string" shouldBe:0],
              @"Distance should be 0 with identical strings.");
}

- (void) testComparisonToEmptyString {
    XCTAssert([self distanceFromString:@"hippo" toString:@"" shouldBe:5],
              @"Distance from 'hippo' to empty string is 5 (length of 'hippo')");
}

- (void) testComparisonFromEmptyString {
    XCTAssert([self distanceFromString:@"" toString:@"elk" shouldBe:3],
              @"Distance from empty string to 'elk' is size of 'elk'");
}

- (void) testSingleAdditionAtEnd {
    XCTAssert([self distanceFromString:@"mat" toString:@"math" shouldBe:1],
              @"Distance from 'mat' to 'math' is 1.");
}

- (void) testSingleDeletionAtEnd {
    XCTAssert([self distanceFromString:@"bath" toString:@"bat" shouldBe:1],
              @"Distance from 'bath' to 'bat' should be 1.");
}

- (void) testSingleInsertInMiddle {
    XCTAssert([self distanceFromString:@"ba" toString:@"bea" shouldBe:1],
              @"Distance from 'ba' to 'bea' should be 1.");
}

- (void) testMultipleInsertions {
    XCTAssert([self distanceFromString:@"gas" toString:@"goats" shouldBe:2],
              @"Distance from 'gas' to 'goats' is two inserts.");
}

- (void) testKittenToSitting {
    XCTAssert([self distanceFromString:@"kitten" toString:@"sitting" shouldBe:3],
              @"Kitten -> Sitting example from wiki article");
}

- (void) testSaturdayToSunday {
    XCTAssert([self distanceFromString:@"Saturday" toString:@"Sunday" shouldBe:3],
              @"Saturday to Sunday test from wiki article");
}

- (void) testSingleTrasposition {
    XCTAssert([self distanceFromString:@"teh" toString:@"the" shouldBe:1],
              @"Distance from 'teh' to 'the' is 1 transposition");
}

- (void) testingComplexError {
    XCTAssert([self distanceFromString:@"aaaaaaaaaaaaaa" toString:@"bbbbbbbbbbbbbb" shouldBe:14],
              @"Should be 5, crazy example");
}

@end
