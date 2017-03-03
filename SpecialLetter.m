//
//  SpecialLetter.m
//  OVAlertView
//
//  Created by 王子翰 on 2017/2/1.
//  Copyright © 2017年 王子翰. All rights reserved.
//

#import "SpecialLetter.h"

@implementation SpecialLetter

+ (BOOL) judgeSpecialLetterWithString:(nonnull NSString*)str
{
    str = [str uppercaseString];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"SpecialLetterList" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    
    for (int i = 0; i < arr.count; i ++)
    {
        NSString *string = arr[i];
        if ([str containsString:string])
        {
            return YES;
        }
    }
    return NO;
}

@end
