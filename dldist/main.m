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

void printUsage() {
    printf("usage: dldist -to toString fromString\n");
}



AppState* parseCommandArguments(int argc, const char * argv[]) {
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    AppState *state = [[AppState alloc] init];
    [state setTo:[standardDefaults stringForKey:@"to"]];
    
    state.from = [NSString stringWithUTF8String:argv[argc - 1]];
    return state;
}

Boolean isAppInRunnableState(AppState *state) {
    if ([state.from length] > 0)
        return YES;
    return NO;
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        AppState *state = parseCommandArguments(argc, argv);
        
        if(isAppInRunnableState(state))
        {
            printf("%lu", [state.from dlDistTo:state.to]);
        }
        
        
    }
    return 0;
}


