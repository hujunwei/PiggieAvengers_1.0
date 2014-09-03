//
//  Congratulation Scene.m
//  Defend my eggs
//
//  Created by Junwei Hu on 14-8-14.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "CongratulationScene.h"

@implementation CongratulationScene

+ (id)scene
{
    CCScene* sc = [CCScene node];
    LevelScene* ls = [[LevelScene alloc] init];
    [sc addChild:ls];
    return sc;
}

- (id) init
{
    self = [super init];
    if (self) {
        //设置背景为可触摸
        [self setIsTouchEnabled:YES];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* congratulationSceneBG = [CCSprite spriteWithFile:@"congratulations.png"];
        [congratulationSceneBG setScale:0.5f];
        [congratulationSceneBG setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        [self addChild:congratulationSceneBG];
        
        CCSprite* menuButton = [CCSprite spriteWithFile:@"menu.png"];
        [menuButton setPosition:ccp(240.0f, 100.0f)];
        [menuButton setScale:0.5f];
        [menuButton setTag:100];
        [self addChild:menuButton];
        
    }
    return self;
}




@end
