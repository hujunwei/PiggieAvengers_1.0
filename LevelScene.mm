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

#define BIRD_CHARACTER 200
#define PIG_CHARACTER 300
#define TITLE_TAG 400
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
        CCSprite* birdCharacter = [CCSprite spriteWithFile:@"angrybirds3d.png"];
        [birdCharacter setPosition:ccp(winSize.width / 3 - 20.0, winSize.height / 2.5)];
        [birdCharacter setScale:0.6f];
        [birdCharacter setTag:BIRD_CHARACTER];
        [self addChild:birdCharacter];
        CCSprite* pigCharacter = [CCSprite spriteWithFile:@"pig.png"];
        [pigCharacter setPosition:ccp(winSize.width / 3 * 2 + 20.0, winSize.height / 2.5)];
        [pigCharacter setScale:1.5f];
        [pigCharacter setTag:PIG_CHARACTER];
        [self addChild:pigCharacter];
        //CCSprite* levelSceneTitle = [CCSprite spriteWithFile:@"levelSceneTitle.png"];
        CCLabelTTF* levelSceneTitle = [CCLabelTTF labelWithString:@"Select Your Character" fontName:@"Scissor Cuts.ttf" fontSize:40.0f];
        [levelSceneTitle setColor:ccc3(255, 255, 0)];
        [levelSceneTitle setPosition:ccp(winSize.width / 2 + 10, winSize.height - 80)];
        [levelSceneTitle setTag:TITLE_TAG];
        CCScaleBy* actionScaleBigger = [CCScaleBy actionWithDuration:1.5f scale:1.5f];
        CCScaleBy* actionScaleSmaller = [CCScaleBy actionWithDuration:1.5f scale:0.67f];
        CCSequence* allActions = [CCSequence actions:actionScaleBigger, actionScaleSmaller, nil];
        CCRepeat* repeatActions = [CCRepeat actionWithAction:allActions times:4];
        [self addChild:levelSceneTitle];
        [levelSceneTitle runAction:repeatActions];
        
    }
    return self;
}

//触摸结束的时候

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //get touch point
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    UITouch* oneTouch = [touches anyObject];
    UIView* touchView = [oneTouch view];
    CGPoint location = [oneTouch locationInView:touchView];
    CGPoint worldGLPoint = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint nodePoint = [self convertToNodeSpace:worldGLPoint];
    for (CCSprite *sp in self.children) {
        if (CGRectContainsPoint(sp.boundingBox, nodePoint) && sp.tag == BIRD_CHARACTER) {
            CCScaleBy* birdButtonAction = [CCScaleBy actionWithDuration:0.3f scale:4.0f];
            CCJumpTo* birdButtonAction1 = [CCJumpTo actionWithDuration:0.3f position:ccp(winSize.width / 2, sp.position.y + 50) height:0.2f jumps:1];
            CCSpawn* allActions = [CCSpawn actions:birdButtonAction1,  birdButtonAction, nil];
            [sp runAction:allActions];
            for (CCSprite* sp in self.children) {
                if (sp.tag == PIG_CHARACTER) {
                     CCRotateTo* pigButtonAction = [CCRotateTo actionWithDuration:0.5f];
                     CCJumpTo* pigButtonAction1 = [CCJumpTo actionWithDuration:0.3f position:ccp(winSize.width + 100, -50) height:0.2f jumps:1];
                    CCSpawn* allActions = [CCSpawn actions:pigButtonAction, pigButtonAction1, nil];
                    [sp runAction:allActions];
                }
                if (sp.tag == TITLE_TAG) {
                    CCJumpTo* titleAction = [CCJumpTo actionWithDuration:0.3f position:ccp(winSize.width /2 , winSize.height + 100) height:0.2f jumps:1];
                    [sp runAction:titleAction];
                }
            }
        }
        else if (CGRectContainsPoint(sp.boundingBox, nodePoint) && sp.tag == PIG_CHARACTER) {
            
            CCScaleBy* pigButtonAction = [CCScaleBy actionWithDuration:0.3f scale:4.0f];
            CCJumpTo* pigButtonAction1 = [CCJumpTo actionWithDuration:0.3f position:ccp(winSize.width / 2, sp.position.y + 50) height:0.2f jumps:1];
            CCSpawn* allActions = [CCSpawn actions:pigButtonAction1, pigButtonAction, nil];
            [sp runAction:allActions];
            for (CCSprite* sp in self.children) {
                if (sp.tag == BIRD_CHARACTER) {
                    CCRotateTo* birdButtonAction = [CCRotateTo actionWithDuration:0.5f];
                    CCJumpTo* birdButtonAction1 = [CCJumpTo actionWithDuration:0.3f position:ccp(-30, -50) height:0.2f jumps:1];
                    CCSpawn* allActions = [CCSpawn actions:birdButtonAction, birdButtonAction1, nil];
                    [sp runAction:allActions];
                }
                if (sp.tag == TITLE_TAG) {
                    CCJumpTo* titleAction = [CCJumpTo actionWithDuration:0.3f position:ccp(winSize.width /2 , winSize.height + 100) height:0.2f jumps:1];
                    [sp runAction:titleAction];
                }
            }

        }
        
    }
    
}



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
        else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == BIRD_CHARACTER) {
            CCScene* sc = [GameScene sceneWithLevel:oneSprite.tag];
            CCTransitionScene* trans = [[CCTransitionPageTurn alloc] initWithDuration:2.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        }
        else if (CGRectContainsPoint(oneSprite.boundingBox, nodePoint) && oneSprite.tag == PIG_CHARACTER) {
            CCScene* sc = [GameScene sceneWithLevel:oneSprite.tag];
            CCTransitionScene* trans = [[CCTransitionPageTurn alloc] initWithDuration:2.0f scene:sc];
            [[CCDirector sharedDirector] replaceScene:trans];
            [trans release];
        }
    }
}



@end
