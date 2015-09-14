//
//  dldistTests.m
//  dldistTests
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSString+dlDistFrom.h"


@interface dldistTests : XCTestCase

@end

@implementation dldistTests

- (void) testIdenticalStrings {
    XCTAssertEqual(0, [@"str" dlDistFrom:@"str"],
              @"Distance should be 0 with identical strings.");
}

- (void) testComparisonToEmptyString {
    XCTAssertEqual(5, [@"hippo" dlDistFrom:@""],
              @"Distance from 'hippo' to empty string is 5 (length of 'hippo')");
}

- (void) testComparisonFromEmptyString {
    XCTAssertEqual(3, [@"" dlDistFrom:@"elk"],
              @"Distance from empty string to 'elk' is size of 'elk'");
}

- (void) testSingleAdditionAtEnd {
    XCTAssertEqual(1, [@"mat" dlDistFrom:@"math"],
              @"Distance from 'mat' to 'math' is 1.");
}

- (void) testSingleDeletionAtEnd {
    XCTAssertEqual(1, [@"bath" dlDistFrom:@"bat"],
              @"Distance from 'bath' to 'bat' should be 1.");
}

- (void) testSingleInsertInMiddle {
    XCTAssertEqual(1, [@"ba" dlDistFrom:@"bea"],
              @"Distance from 'ba' to 'bea' should be 1.");
}

- (void) testMultipleInsertions {
    XCTAssertEqual(2, [@"gas" dlDistFrom:@"goats"],
              @"Distance from 'gas' to 'goats' is two inserts.");
}

- (void) testKittenToSitting {
    XCTAssertEqual(3, [@"kitten" dlDistFrom:@"Sitting"],
              @"Kitten -> Sitting example from wiki article");
}

- (void) testSaturdayToSunday {
    XCTAssertEqual(3, [@"Saturday" dlDistFrom:@"Sunday"],
              @"Saturday to Sunday test from wiki article");
}

- (void) testSingleTrasposition {
    XCTAssertEqual(1, [@"teh" dlDistFrom:@"the"],
              @"Distance from 'teh' to 'the' is 1 transposition");
}

- (void) testingComplexError {
    XCTAssertEqual(10, [@"aacedfgihjjklmonprrtvxwez" dlDistFrom:@"abcdefghijklmnopqrstuvwxyz"],
              @"Complex error");
}

- (void) testingLongestWord {
    XCTAssertEqual(1, [@"pneumonoultramicroscopicsilicovolcanoconiossi" dlDistFrom:
                       @"pneumonoultramicroscopicsilicovolcanoconiosis"],
                   @"Long Word, dist 1");
}

- (void) testingTranspositionInFirstCharacters {
    XCTAssertEqual(1, [@"hte" dlDistFrom:@"the"],
                   @"Dist should be 1");
}



@end
