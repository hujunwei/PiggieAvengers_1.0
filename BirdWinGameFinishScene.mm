//
//  BirdWinGameFinishScene.m
//  AngryBirds
//
//  Created by Junwei Hu on 14-8-5.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "BirdWinGameFinishScene.h"

@implementation BirdWinGameFinishScene

+ (id)scene
{
    CCScene* sc = [CCScene node];
    BirdWinGameFinishScene* finishSC = [[BirdWinGameFinishScene alloc] init];
    [sc addChild:finishSC];
    return sc;
}

+ (id)sceneWithLevel:(int)level
{
    CCScene* sc = [CCScene node];
    BirdWinGameFinishScene* gs = [BirdWinGameFinishScene nodeWithLevel:level];
    [sc addChild:gs];
    //[gs release];
    return sc;
}

+ (id)nodeWithLevel:(int)level
{
    return [[[self alloc] initWithLevel:level] autorelease];
}



- (id)initWithLevel:(int)level
{
    self = [super init];
    if (self) {
        currLevel = level;
        // 标准init方法
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 通过导演类CCDirector来获取屏幕的宽高
        CCSprite *sp = [CCSprite spriteWithFile:@"选关.png"];
        // 创建了一个精灵对象，这个对象就是一张图片
        //[sp setScale:0.5f];
        [sp setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
        // ccp = CGPointMake
        // 设置精灵的中心坐标
        [self addChild:sp];
        // 把精灵加入到self中 self就是节目
       
        
        //添加you win / you lose 动态效果
        /*
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"You Win" fontName:@"Schwarzwald Regular" fontSize:32];
        id actionScale = [CCScaleTo actionWithDuration:0.0f scale:0.4f];
        id actionScale2 = [CCScaleBy actionWithDuration:0.5f scale:2.0f];
        CCSequence* allLabelActions = [CCSequence actions:actionScale, actionScale2, nil];
        label.position = ccp(winSize.width / 2.0f , winSize.height / 1.3f);
        [label runAction:allLabelActions];
        [self addChild:label];
         */
        [self performSelector:@selector(winLoseLabel) withObject:nil afterDelay:0.8f];
        
        //小鸟和猪开始跳跃
       [self schedule:@selector(tick:) interval:1.0f];
        
        
        
        
        //加雪花效果
        CCParticleSystem *snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        [self addChild:snow];
    }
    return self;
}

-(void) winLoseLabel{
    //添加you win / you lose 动态效果
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"You're defeated!" fontName:@"Schwarzwald Regular" fontSize:20];
    id actionScale = [CCScaleTo actionWithDuration:0.0f scale:0.4f];
    id actionScale2 = [CCScaleBy actionWithDuration:0.5f scale:7.0f];
    id actionScale3 = [CCScaleBy actionWithDuration:0.5f scale:0.8f];
    CCSequence* allLabelActions = [CCSequence actions:actionScale, actionScale2, actionScale3, nil];
    label.position = ccp(240.0f, 250.0f);
    [label setColor:ccc3(250,0,0)];
    [label runAction:allLabelActions];
    [self addChild:label];
    
    //加一个菜单
    //replay 按钮
    CCSprite* replaySprite = [CCSprite spriteWithFile:@"restart.png"];
    [replaySprite setScale: 0.5f];
    //[replaySprite setPosition:ccp(12.0f, 0.0f)];
    CCMenuItemSprite *replayMenuItem = [CCMenuItemSprite itemFromNormalSprite:replaySprite selectedSprite:nil target:self selector:@selector(replayGame:)];
    //selectLevel 按钮
    CCSprite* selectLvSprite = [CCSprite spriteWithFile:@"menu.png"];
    [selectLvSprite setScale:0.5f];
    //[selectLvSprite setPosition:ccp(200.0f, 0.0f)];
    CCMenuItemSprite* selectLvMenuItem = [CCMenuItemSprite itemFromNormalSprite:selectLvSprite selectedSprite:nil target:self selector:@selector(selectLevel:)];
    CCSprite* menu =  [CCMenu menuWithItems:replayMenuItem, nil];
    CCSprite* menu2 =  [CCMenu menuWithItems:selectLvMenuItem, nil];
    [menu setPosition:ccp(190.0f,120.0f)];
    [menu2 setPosition:ccp(350.0f,120.0f)];
    [self addChild:menu];
    [self addChild:menu2];


}


- (void)tick:(double) dt
{
    //小鸟动作
    CCSprite* bird = [CCSprite spriteWithFile:@"bird1.png"];
    //创建一个跳跃动作，条约时间是2.0s， 跳到endpoint， 跳一次
    [bird setScale:(arc4random() % 5 / 10.0f)];
    [bird setPosition:ccp(120.0f + arc4random() % 50, 150.0f)];
    CGPoint endPoint = ccp(120.0f + arc4random() % 50, 200.0f);
    CGFloat height = 50.0f;
    id actionJump = [CCJumpTo actionWithDuration:2.0f position:endPoint height:height jumps:1];
    //创建一个完成动作
    id actionFinish = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    //把所有动作按顺序连接起来
    CCSequence* allActions = [CCSequence actions: actionJump, actionFinish, nil];
    [bird runAction:allActions];
    [self addChild:bird];
    // [bird release];
    
    //小猪动作
    NSString* pigName = [NSString stringWithFormat:@"bird1.png"];
    CCSprite* pig = [CCSprite spriteWithFile:pigName];
    //创建一个跳跃动作，条约时间是2.0s， 跳到endpoint， 跳一次
    [pig setScale:(arc4random() % 5 / 10.0f)];
    [pig setPosition:ccp(360.0f + arc4random() % 50, 150.0f)];
    CGPoint endPointPig = ccp(360.0f + arc4random() % 50, 200.0f);
    CGFloat heightPig = 50.0f;
    id actionJumpPig = [CCJumpTo actionWithDuration:2.0f position:endPointPig height:heightPig jumps:1];
    //创建一个完成动作
    id actionFinishPig = [CCCallFuncN actionWithTarget:self selector:@selector(actionFinish:)];
    //把所有动作按顺序连接起来
    CCSequence* allActionsPig = [CCSequence actions: actionJumpPig, actionFinishPig, nil];
    [pig runAction:allActionsPig];
    [self addChild:pig];
}


-(void) actionFinish:(CCNode*) currentNode
{
    CCParticleSystem* explosion = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    [explosion setPosition:[currentNode position]];
    [self addChild:explosion];
    [currentNode removeFromParentAndCleanup:YES];
}

-(void) actionFinishPig:(CCNode*) currentNode
{
    CCParticleSystem* explosion = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    [explosion setPosition:[currentNode position]];
    [self addChild:explosion];
    [currentNode removeFromParentAndCleanup:YES];
}



-(void)replayGame:(id)arg
{
    NSLog(@"replay game");
    NSLog(@"currLevel is %d",currLevel);
    CCScene* gameScene = [GameScene sceneWithLevel:currLevel];
    CCTransitionScene* trans = [[CCTransitionPageTurn alloc] initWithDuration:0.5f scene:gameScene backwards:YES];
    [[CCDirector sharedDirector] replaceScene:trans];
    [trans release];
}

-(void)selectLevel:(id)arg
{
    NSLog(@"select level");
    CCScene* levelScene = [LevelScene scene];
    CCTransitionScene* trans = [[CCTransitionJumpZoom alloc] initWithDuration:0.5f scene:levelScene];
    [[CCDirector sharedDirector] replaceScene:trans];
    [trans release];
}
@end
