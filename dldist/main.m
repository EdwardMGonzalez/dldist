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
    printf(" [-dictionary path_to_file] fromString\n\n");
    
    printf("\t -to toString: \n");
    printf("\tUsed for simple comparison from one string to another\n\n");
    
    printf("\t -dictionary path_to_file:\n");
    printf("\tThe file should have each word on a new line.");
    printf(" For each line the distance will be computed relative to");
    printf(" fromString\n\n");
}

// pull out state from command line
AppState* parseCommandArguments(int argc, const char * argv[]) {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    AppState *state = [[AppState alloc] init];
    
    [state setTo:[standardDefaults stringForKey:@"to"]];

    NSString *tmpPath = [standardDefaults stringForKey:@"dictionary"];
    [state setPathToDictionary:[tmpPath stringByStandardizingPath]];
    
    state.from = [NSString stringWithUTF8String:argv[argc - 1]];
    
    return state;
}

// can we execute?
Boolean isAppInRunnableState(AppState *state) {
    if ([state.from length] > 0) {
        if ([state.to length] > 0) {
            return YES;
        } else if ([state.pathToDictionary length] > 0) {
            return YES;
        }
    }
    return NO;
}


NSArray * getWordListFromDictionary(AppState *state) {
    NSError *error;
    NSString *fileContents = [[NSString alloc] initWithContentsOfFile:state.pathToDictionary
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
    NSArray *wordList = getWordListFromDictionary(state);
    
    NSArray *bestMatches = [[NSArray alloc] init];
    unsigned long closestDistance = NSUIntegerMax;
    
    for (NSString *to in wordList) {
        unsigned long dist = [state.from dlDistTo:to];
        if (dist < closestDistance) {
            closestDistance = dist;
            bestMatches = [NSArray arrayWithObject:to];
        } else if (dist == closestDistance) {
            bestMatches = [bestMatches arrayByAddingObject:to];
        }
    }
    
    if(closestDistance == NSUIntegerMax) return;
    
    printf("%lu: ", closestDistance);
    
    for (NSString *word in bestMatches) {
        printf("%s ", [word cStringUsingEncoding:NSUTF8StringEncoding]);
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


