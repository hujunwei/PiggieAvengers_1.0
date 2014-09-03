//
//  GameUtil.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/1/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "GameUtil.h"

@implementation GameUtil
+ (NSString*) getSuccessLevelFilePath
{
    //得到存放成功通关的文件
    return [[NSHomeDirectory() stringByAppendingString:@"Documents"] stringByAppendingString:@"successlevel"];
}

+ (id) readLevelFromFile
{
    NSString* file = [[self class] getSuccessLevelFilePath];
    NSString* s = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    if (s) {
        return [s intValue];
    }
    return 5; //2是缺省关卡
}


+ (void) writeLevelToFile:(int) level
{
    NSString* s = [NSString stringWithFormat:@"%d", level];
    NSString* file = [[self class] getSuccessLevelFilePath];
    [s writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}


@end
