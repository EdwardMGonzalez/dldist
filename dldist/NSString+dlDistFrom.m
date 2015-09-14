//
//  NSString+dlDistFrom.m
//  dldist
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import "NSString+dlDistFrom.h"

@implementation NSString (dlDistFrom)

- (unsigned long) dlDistFrom:(NSString *)str {
    // simple cases
    if ([self isEqualToString:str]) return 0;
    if (0 == self.length) return str.length;
    if (0 == str.length) return self.length;
    
    
    // prep matrix
    unsigned long matrix[self.length + 1][str.length + 1];
    for (unsigned long i = 0; i <= self.length; i++) matrix[i][0] = i;
    for (unsigned long j = 0; j <= str.length; j++) matrix[0][j] = j;
    
    // fill matrix
    for (unsigned long i = 1; i <= self.length; i++){
        for (unsigned long j = 1; j <= str.length; j++) {
            if ([self characterAtIndex:i - 1] == [str characterAtIndex:j - 1]) {
                matrix[i][j] = matrix[i - 1][j - 1];
            } else {
                unsigned long delete = matrix[i][j - 1] + 1;
                unsigned long insert = matrix[i - 1][j] + 1;
                unsigned long subst = matrix[i - 1][j - 1] + 1;
                
                unsigned long levenshtein = MIN(delete, MIN(insert, subst));
                
                if ([self isTransposition:self atIndex:i withString:str atIndex:j]) {
                    matrix[i][j] = matrix[i - 2][j - 2] + 1;
                } else {
                    // no transposition
                    matrix[i][j] = levenshtein;
                }
            }
        }
    }
    
    return matrix[self.length][str.length];
}


- (Boolean) isTransposition:(NSString *)str1 atIndex:(unsigned long)i
                 withString:(NSString *) str2 atIndex:(unsigned long)j {
    if(i > 2 && j > 2)
        if([str1 characterAtIndex:i - 2] == [str2 characterAtIndex:j - 1])
            if([str1 characterAtIndex:i - 1] == [str2 characterAtIndex:j - 2])
                return YES;
    return NO;
}

@end
