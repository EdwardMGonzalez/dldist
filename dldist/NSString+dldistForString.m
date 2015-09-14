//
//  NSString+dlDistForString.m
//  dldist
//
//  Calculating the Damerau-Levenshtein distance:
//  The editing distance between two words where the allowed
//  operations are insert, delete, substitute, and transpose.
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//
//  Work based off of the wiki article:
//  https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance

#import "NSString+dlDistForString.h"

@implementation NSString (dldistForString)


- (unsigned long)getDistanceForInsertionInto:(NSString *)base
                                     toMatch:(NSString *)other {
    NSString *otherSubstr = [other substringToIndex:[other length] - 1];
    unsigned long dist = [base dlDistFromString:otherSubstr];
    return dist + 1; //adding 1 for the insert operation
}

- (unsigned long)getDistanceForDeletionFrom:(NSString *)base
                                    toMatch:(NSString *)other {
    NSString *baseSubstr = [base substringToIndex:[base length] -1];
    unsigned long dist = [baseSubstr dlDistFromString:other];
    return dist + 1; //adding 1 for the delete operation
}

- (unsigned long)getValueForIndicator:(NSString *)base
                                other:(NSString *)other {
    char b = [base characterAtIndex:[base length] - 1];
    char o = [other characterAtIndex:[other length] - 1];
    unsigned long weight =  b == o ? 0 : 1;
    return weight;
}

- (unsigned long)getDistanceForMatchOrMismatch:(NSString *)base
                                       toMatch:(NSString *)other {
    unsigned long weightForMismatch = [self getValueForIndicator:base other:other];
    NSString *baseSubstr = [base substringToIndex: [base length] - 1];
    NSString *otherSubstr = [other substringToIndex:[other length] - 1];
    return [baseSubstr dlDistFromString:otherSubstr] + weightForMismatch;
}

- (unsigned long) getDistanceForTransposition:(NSString *)base
                                      toMatch:(NSString *)other {
    NSString *baseSubstr = [base substringToIndex:[base length] - 2];
    NSString *otherSubstr = [base substringToIndex:[other length] - 2];
    unsigned long dist = [baseSubstr dlDistFromString:otherSubstr];
    return dist + 1;
}

- (Boolean) isTransposed: (NSString *) base
                    with:(NSString *)other {
    unsigned long baseLength = [base length];
    unsigned long otherLength = [other length];
    
    // do we have enough chars to be transposed?
    if(baseLength <= 1 || otherLength <= 1) return NO;
    
    char b1 = [base characterAtIndex:baseLength - 1];
    char b2 = [base characterAtIndex:baseLength - 2];
    char o1 = [other characterAtIndex:otherLength - 1];
    char o2 = [other characterAtIndex:otherLength - 2];
    
    if (b1 == o2 && b2 == o1) return YES; // we are transposed
        
    return NO;
}

- (unsigned long) dlDistFromString:(NSString*) other {
    // first thing's first, are the strings identical?
    if([self isEqualToString:other]) return 0;
    
    // save lengths
    unsigned long myLength = [self length];
    unsigned long otherLength = [other length];
    
    // test for lengths of 0
    if (0==myLength) return otherLength;
    if (0==otherLength) return myLength;
    
    unsigned long distForInsertion =
        [self getDistanceForInsertionInto:self toMatch:other];
    unsigned long distForDeletion =
        [self getDistanceForDeletionFrom:self toMatch:other];
    unsigned long distForMatch =
        [self getDistanceForMatchOrMismatch:self toMatch:other];
    
    unsigned long levenshteinDist = MIN(distForInsertion,
                                        MIN(distForDeletion, distForMatch));
    
    if ([self isTransposed:self with:other]) {
        unsigned long distForTransposition =
            [self getDistanceForTransposition:self toMatch:other];
        return MIN(levenshteinDist, distForTransposition);
    }
    
    return levenshteinDist;
}




@end
