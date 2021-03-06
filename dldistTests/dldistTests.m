//
//  dldistTests.m
//  dldistTests
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSString+dlDistTo.h"


@interface dldistTests : XCTestCase

@end

@implementation dldistTests

- (void) testIdenticalStrings {
    XCTAssertEqual(0, [@"str" dlDistTo:@"str"],
              @"Distance should be 0 with identical strings.");
}

- (void) testComparisonToEmptyString {
    XCTAssertEqual(5, [@"hippo" dlDistTo:@""],
              @"Distance from 'hippo' to empty string is 5 (length of 'hippo')");
}

- (void) testComparisonFromEmptyString {
    XCTAssertEqual(3, [@"" dlDistTo:@"elk"],
              @"Distance from empty string to 'elk' is size of 'elk'");
}

- (void) testSingleAdditionAtEnd {
    XCTAssertEqual(1, [@"mat" dlDistTo:@"math"],
              @"Distance from 'mat' to 'math' is 1.");
}

- (void) testSingleDeletionAtEnd {
    XCTAssertEqual(1, [@"bath" dlDistTo:@"bat"],
              @"Distance from 'bath' to 'bat' should be 1.");
}

- (void) testSingleInsertInMiddle {
    XCTAssertEqual(1, [@"ba" dlDistTo:@"bea"],
              @"Distance from 'ba' to 'bea' should be 1.");
}

- (void) testMultipleInsertions {
    XCTAssertEqual(2, [@"gas" dlDistTo:@"goats"],
              @"Distance from 'gas' to 'goats' is two inserts.");
}

- (void) testKittenToSitting {
    XCTAssertEqual(3, [@"kitten" dlDistTo:@"Sitting"],
              @"Kitten -> Sitting example from wiki article");
}

- (void) testSaturdayToSunday {
    XCTAssertEqual(3, [@"Saturday" dlDistTo:@"Sunday"],
              @"Saturday to Sunday test from wiki article");
}

- (void) testSingleTrasposition {
    XCTAssertEqual(1, [@"teh" dlDistTo:@"the"],
              @"Distance from 'teh' to 'the' is 1 transposition");
}

- (void) testingComplexError {
    XCTAssertEqual(10, [@"aacedfgihjjklmonprrtvxwez" dlDistTo:@"abcdefghijklmnopqrstuvwxyz"],
              @"Complex error");
}

- (void) testingLongestWord {
    XCTAssertEqual(1, [@"pneumonoultramicroscopicsilicovolcanoconiossi" dlDistTo:
                       @"pneumonoultramicroscopicsilicovolcanoconiosis"],
                   @"Long Word, dist 1");
}

- (void) testingTranspositionInFirstCharacters {
    XCTAssertEqual(1, [@"hte" dlDistTo:@"the"],
                   @"Dist should be 1");
}

- (void) testSpaceInString {
    XCTAssertEqual(1, [@"sky line" dlDistTo:@"skyline"],
                   @"Distance from 'sky line' to 'skyline' is one delete");
}




@end
