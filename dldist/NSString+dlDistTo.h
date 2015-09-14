//
//  NSString+dlDistFrom.h
//  dldist
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//
// Work is based on the wiki article:
// https://en.wikipedia.org/wiki/Damerau–Levenshtein_distance

#import <Foundation/Foundation.h>

@interface NSString (dlDistTo)

- (unsigned long) dlDistTo: (NSString *) str;

@end
