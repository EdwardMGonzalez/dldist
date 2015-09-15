//
//  main.m
//  dldist
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+dlDistTo.h"
#import "AppState.h"

// let folks know how to call us
void printUsage() {
    printf("usage: dldist [-to to_string] [-from from_string]");
    printf(" [-dictionary path_to_dictionary_file] [-list path_to_check_list]");
    printf("\n\n");
    
    printf("\t -to to_string: \n");
    printf("\tUsed for simple comparison from one string to another\n\n");
    
    printf("\t -from from_string: \n");
    printf("\tUsed for simple comparison from one string to another\n\n");
    
    printf("\t -dictionary path_to_dictionary_file:\n");
    printf("\tThe file should have each word on a new line.");
    printf(" For each line the distance will be computed relative to");
    printf(" from_string or each element of check_list.");
    printf(" If -list is used, from_string is ignored\n\n");
    
    
    printf("\t -list path_to_file:\n");
    printf("\tThe file should have each word on a new line.");
    printf(" For each line the distance will be computed relative from");
    printf(" each line. if -list is used, from_string is ignored\n\n");
}

// pull out state from command line
AppState* parseCommandArguments(int argc, const char * argv[]) {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];

    AppState *state = [[AppState alloc] init];
    state.pathToDictionary = [[standardDefaults stringForKey:@"dictionary"] stringByStandardizingPath];
    state.pathToCheckList = [[standardDefaults stringForKey:@"list"] stringByStandardizingPath];
    state.to = [standardDefaults stringForKey:@"to"];
    state.from = [standardDefaults stringForKey:@"from"];
    
    return state;
}

// can we execute?
Boolean isAppInRunnableState(AppState *state) {
    
    Boolean hasFrom = state.from.length > 0;
    Boolean hasTo = state.to.length > 0;
    Boolean hasDictionary = state.pathToDictionary.length > 0;
    Boolean hasCheckList = state.pathToCheckList.length > 0;
    
    if (!(hasFrom || hasCheckList)) {
        // we need an origin to check distance
        return NO;
    }
    if (!(hasTo || hasDictionary)){
        // we need a destination to check distance
        return NO;
    }

    return YES;
}


NSArray * getWordListFromFile(NSString *path) {
    NSError *error;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:path
                                                             encoding:NSUTF8StringEncoding error:&error];
    if ([error.localizedDescription length] > 0) {
        NSLog(@"Error loading file: %@\n", path);
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    NSCharacterSet *separators = [NSCharacterSet newlineCharacterSet];
    NSArray *wordList = [fileContents componentsSeparatedByCharactersInSet:separators];
    return wordList;
}

NSArray* prepWordsToCheck(AppState *state) {
    NSArray *wordsToCheck;
    if(state.pathToCheckList.length > 0)
    {
        wordsToCheck = getWordListFromFile(state.pathToCheckList);
    } else {
        wordsToCheck = [NSArray arrayWithObject:state.from];
    }
    return wordsToCheck;
}

NSArray* prepDictionary(AppState *state) {
    NSArray *dictionaryWords;
    if (state.pathToDictionary.length > 0){
        dictionaryWords = getWordListFromFile(state.pathToDictionary);
    } else {
        dictionaryWords = [NSArray arrayWithObject:state.to];
    }
    return dictionaryWords;
}

void findDistances(AppState *state) {
    NSArray *wordsToCheck = prepWordsToCheck(state);
    NSArray *dictionaryWords = prepDictionary(state);
    
    
    // walk through the check list
    for (NSString *from in wordsToCheck) {
        // prep the for matches
        unsigned long closestDistance = NSUIntegerMax;
        NSArray *bestMatches = [[NSArray alloc] init];
        
        //  walk through the dictionary
        for (NSString *to in dictionaryWords) {
            unsigned long dist = [from dlDistTo:to];
            if (dist < closestDistance) {
                closestDistance = dist;
                bestMatches = [NSArray arrayWithObject:[to copy]];
                if (0 == dist) break; // exact match, we can stop searching
            } else if (dist == closestDistance) {
                bestMatches = [bestMatches arrayByAddingObject:[to copy]];
            }
        }
        
        // assume we found a match when distance isn't max integer size
        if(closestDistance != NSUIntegerMax) {
            printf("%lu: [%s]  ", closestDistance,
                   [from cStringUsingEncoding:NSUTF8StringEncoding]);
            for (NSString *word in bestMatches) {
                printf("'%s' ", [word cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            printf("\n");
            fflush(stdout);
        }
    }
}

// entry point
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AppState *state = parseCommandArguments(argc, argv);
        
        if (isAppInRunnableState(state)) {
            findDistances(state);
        }
        else {
            printUsage();
        }
    }
    return 0;
}


