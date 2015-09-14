//
//  main.m
//  dldist
//
//  Created by Ed Gonzalez on 9/13/15.
//  Copyright (c) 2015 Ed Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+dlDistFrom.h"

void printUsage() {
    printf("usage: dldist str1 str2\n");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if(argc < 3) {
            printUsage();
            return 0;
        }
        
        NSString *str1 = [NSString stringWithCString:argv[1]
                                            encoding:NSUTF8StringEncoding];
        str1 = [str1 lowercaseString];
        NSString *str2 = [NSString stringWithCString:argv[2]
                                            encoding:NSUTF8StringEncoding];
        str2 = [str2 lowercaseString];
        
        printf("%lu", [str1 dlDistFrom:str2]);
        
    }
    return 0;
}
