//
//  JsonParser.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/10/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "JsonParser.h"
#import "SBJson.h"

@implementation spriteModel

@synthesize  tag, x, y, angle;

@end


@implementation JsonParser

+ (id)getAllSprite:(NSString *)file
{
    NSString* levelContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    //读取文件里面的所有内容
    NSArray* spriteArray = [[[levelContent JSONValue] objectForKey:@"sprites"] objectForKey:@"sprite"];
    NSMutableArray* a = [NSMutableArray array];
    for (NSDictionary* dict in spriteArray) {
        spriteModel* sm = [[spriteModel alloc] init];
        sm.tag = [[dict objectForKey:@"tag"] intValue];
        sm.x = [[dict objectForKey:@"x"] floatValue];
        sm.y = [[dict objectForKey:@"y"] floatValue];
        sm.angle = [[dict objectForKey:@"angle"] intValue];
        [a addObject:sm];
        [sm release];
    }
    //从数据中读取所有精灵对象
    return a;
}

@end
