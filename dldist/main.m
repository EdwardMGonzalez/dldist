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
    printf("usage: dldist [-to toString]");
    printf(" [-dictionary path_to_file] [-list path_to_file]");
    printf(" fromString\n\n");
    
    printf("\t -to toString: \n");
    printf("\tUsed for simple comparison from one string to another\n\n");
    
    printf("\t -dictionary path_to_file:\n");
    printf("\tThe file should have each word on a new line.");
    printf(" For each line the distance will be computed relative to");
    printf(" fromString\n\n");
    
    
    printf("\t -list path_to_file:\n");
    printf("\tThe file should have each word on a new line.");
    printf(" For each line the distance will be computed relative from");
    printf(" each line. if -list is used, fromString is ignored\n\n");
}

// pull out state from command line
AppState* parseCommandArguments(int argc, const char * argv[]) {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    AppState *state = [[AppState alloc] init];
    
    [state setTo:[standardDefaults stringForKey:@"to"]];

    NSString *tmpPath = [standardDefaults stringForKey:@"dictionary"];
    [state setPathToDictionary:[tmpPath stringByStandardizingPath]];
    
    tmpPath = [standardDefaults stringForKey:@"list"];
    [state setPathToCheckList:[tmpPath stringByStandardizingPath]];
    
    state.from = [NSString stringWithUTF8String:argv[argc - 1]];
    
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
        NSLog(@"%@", [error localizedDescription]);
        return nil;
    }
    NSCharacterSet *separators = [NSCharacterSet newlineCharacterSet];
    NSArray *wordList = [fileContents componentsSeparatedByCharactersInSet:separators];
    return wordList;
}

void processDictionary(AppState *state) {
    // prep dictionary
    NSArray *dictionaryWords = getWordListFromFile(state.pathToDictionary);
    
    // prep check list (one or more entries)
    NSArray *wordsToCheck;
    if(state.pathToCheckList.length > 0)
    {
        wordsToCheck = getWordListFromFile(state.pathToCheckList);
    } else {
        wordsToCheck = [NSArray arrayWithObject:state.from];
    }
    
    // walk through the check list
    for (NSString *from in wordsToCheck) {
        // prep the for matches
        unsigned long closestDistance = NSUIntegerMax;
        NSArray *bestMatches = [[NSArray alloc] init];
        
        // search for a match
        for (NSString *to in dictionaryWords) {
            unsigned long dist = [from dlDistTo:to];
            if (dist < closestDistance) {
                closestDistance = dist;
                bestMatches = [NSArray arrayWithObject:[to copy]];
                if (0 == dist) break;
            } else if (dist == closestDistance) {
                bestMatches = [bestMatches arrayByAddingObject:[to copy]];
            }
        }
        
        if(closestDistance != NSUIntegerMax) {
            printf("%lu: [%s]  ", closestDistance,
                   [from cStringUsingEncoding:NSUTF8StringEncoding]);
            for (NSString *word in bestMatches) {
                printf("'%s' ", [word cStringUsingEncoding:NSUTF8StringEncoding]);
            }
            printf("\n");
        }
    }
}

// entry point
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AppState *state = parseCommandArguments(argc, argv);
        
        if (isAppInRunnableState(state)) {
            if ([state.to length] > 0) {
                printf("%lu", [state.from dlDistTo:state.to]);
            } else if ([state.pathToDictionary length] > 0) {
                processDictionary(state);
            } else printUsage();
        }
        else {
            printUsage();
        }
    }
    return 0;
}


