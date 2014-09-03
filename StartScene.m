//
//  StartScene.m
//  AngryBirds
//
//  Created by Junwei Hu on 6/29/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "StartScene.h"
#import "ParticleManager.h"
#import "LevelScene.h"
@implementation StartScene

+ (id)scene
{
    CCScene* sc = [CCScene node];
    StartScene* startSC = [[StartScene alloc] init];
    [sc addChild:startSC];
    return sc;
}


- (void)beginGame:(id)arg
{
    NSLog(@"开始游戏");
    CCScene* ls = [LevelScene scene];
    CCTransitionScene* trans = [[CCTransitionSplitRows alloc] initWithDuration:0.5f scene:ls];
    [[CCDirector sharedDirector] replaceScene:trans];
    
}

- (id)init
{
    self = [super init];
    if (self) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCSprite* startBG = [CCSprite spriteWithFile:@"loading.png"];
        [startBG setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        [self addChild:startBG];
        CCSprite* titleSprite = [CCSprite spriteWithFile:@"actitle.png"];
        [titleSprite setPosition:ccp(472, 250)];
        [titleSprite setScale:0.9f];
        [self addChild:titleSprite];
        //加上一个菜单
        CCSprite* beginSprite = [CCSprite spriteWithFile:@"开始.png"];
        [beginSprite setScale:0.8f];
        CCMenuItemSprite* beginMenuItem = [CCMenuItemSprite itemFromNormalSprite:beginSprite selectedSprite:nil target:self selector:@selector(beginGame:)];
        CCMenu* menu = [CCMenu menuWithItems:beginMenuItem, nil];
        [menu setPosition:ccp(260.0f, 120.0f)];
        [self addChild:menu];
        //设置一个schedule调用小鸟
        [self schedule:@selector(tick:) interval:1.0f];
        //加上雪花效果
        /*
        CCParticleSystem* snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        [self addChild:snow];*/
    }
    return self;
}

- (void)tick:(double) dt
{
    CCSprite* bird = [CCSprite spriteWithFile:@"bird1.png"];
    //创建一个跳跃动作，条约时间是2.0s， 跳到endpoint， 跳一次
    [bird setScale:(arc4random() % 5 / 10.0f)];
    [bird setPosition:ccp(50.0f + arc4random() % 50, 70.0f)];
    CGPoint endPoint = ccp(360.0f + arc4random() % 50, 70.0f);
    CGFloat height = arc4random() % 100 + 50.0f;
    id actionJump = [CCJumpTo actionWithDuration:2.0f position:endPoint height:height jumps:1];
    //创建一个完成动作
    id actionFinish = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    //把所有动作按顺序连接起来
    CCSequence* allActions = [CCSequence actions: actionJump, actionFinish, nil];
    [bird runAction:allActions];
    [self addChild:bird];
   // [bird release];
    
}


-(void) actionFinish:(CCNode*) currentNode
{
    CCParticleSystem* explosion = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    [explosion setPosition:[currentNode position]];
    [self addChild:explosion];
    [currentNode removeFromParentAndCleanup:YES];
}



@end
