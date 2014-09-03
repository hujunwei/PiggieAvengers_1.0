//
//  LevelScene.m
//  AngryBirds
//
//  Created by Junwei Hu on 6/30/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "LevelScene.h"
#import "GameUtil.h"
#import "StartScene.h"
#import "cocos2d.h"
#import "GameScene.h"
@implementation LevelScene

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
        CCSprite* levelSceneBG = [CCSprite spriteWithFile:@"congratulations1.png"];
        //[levelSceneBG setScale:0.7f];
        [levelSceneBG setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        [self addChild:levelSceneBG];

        CCSprite* backButton = [CCSprite spriteWithFile:@"backarrow.png"];
        [backButton setPosition:ccp(40.0f, 40.0f)];
        [backButton setScale:0.5f];
        [backButton setTag:100];
        [self addChild:backButton];
        
        //加上14关
        successlevel = [GameUtil readLevelFromFile];
        NSString* imgPath = nil;
        for (int i = 0; i < 14; i++) {
            if (i < successlevel) {
                //已经通关了的
                imgPath = @"level.png";
                NSString* str = [NSString stringWithFormat:@"%d", i+1];
                //CCLabelTTF* numLabel = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(60.0f, 60.0f) alignment: UITextAlignmentCenter fontName:@"Marker Flet" fontSize:30.0f];
                //CCLabelTTF* numLabel = [CCLabelTTF labelWithString:str fontName:@"Marker Flet" fontSize:30.0f];
                CCLabelTTF *numLabel = [CCLabelTTF labelWithString:str dimensions:CGSizeMake(60.0f, 60.0f) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:30.0f];
                float x = 60 + i % 7 * 60;
                float y = 320 - 75 -i / 7 * 80;
                [numLabel setPosition:ccp(x, y)];
                [self addChild:numLabel z:2];
            }
            else {
                //加锁的关卡
                imgPath = @"clock.png";
            }
            CCSprite* levelSprite = [CCSprite spriteWithFile:imgPath];
            [levelSprite setTag:i+1];
            float x = 60 + i % 7 * 60;
            float y = 320 - 60 -i / 7 * 80;
            [levelSprite setPosition:ccp(x, y)];
            [levelSprite setScale:0.6f];
            [self addChild:levelSprite z:1];
        }
    

    }
    return self;
}

//触摸结束的时候
//touches就是触摸点的集合
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //拿到触摸点
    UITouch* oneTouch = [touches anyObject];
    UIView* touchView = [oneTouch view];
    //取得当前一个UIview
    //这里的touchView其实就是GLview
    CGPoint location = [oneTouch locationInView:touchView];
    //转成world GL point
    CGPoint worldGLPoint = [[CCDirector sharedDirector] convertToGL:location];
    //把world坐标转换为node的坐标
    CGPoint nodePoint = [self convertToNodeSpace:worldGLPoint];
    for (int i = 0; i < self.children.count; i++) {
        CCSprite* oneSprite = [self.children objectAtIndex:i];
        if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == 100) {
            //返回上一个剧场
            CCScene* sc = [StartScene scene];
            CCTransitionScene* trans = [[CCTransitionRadialCCW alloc] initWithDuration:1.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        }
        else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag > 0 && oneSprite.tag < successlevel + 1) {
            NSLog(@"选中了第 %d 关", i - 1);
            CCScene* sc = [GameScene sceneWithLevel:oneSprite.tag];
            CCTransitionScene* trans = [[CCTransitionPageTurn alloc] initWithDuration:1.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        }
    }
}
@end
