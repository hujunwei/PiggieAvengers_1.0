//
//  GameScene.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/1/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
//#import "JsonParser.h"
#import "SpriteBase.h"
#import "Bird.h"
#import "Pig.h"
#import "Ice.h"
#import "slingShot.h"
#import "myContactListener.h"
#import "ParticleManager.h"
#import "Egg.h"
#import "BigGun.h"
#import "longWood.h"
#import "ShortWood.h"
#import "BirdWinGameFinishScene.h"
#import "PigWinGameFinishScene.h"
//#define PTM_RATIO 32
@interface GameScene : CCLayer<SpriteDelegate, CCTargetedTouchDelegate>
{
    int numWaves;
    int currentLevel;
    int gameReadyCount;
    int totalNumWaves;
    CCLabelTTF* scoreLabel;
    int score;
    CCSprite* rampageButton;
    CCSprite* rampageButtonCool;
    //CCSprite* blowBigButton;
    CCProgressTimer* blowBigCD;
    CCSprite* bgSprite;
    //大炮
    CCSprite* bigGun;
    CCSprite* shieldSkillButton;
    CCSprite* shieldSkillButtonCool;
    CCProgressTimer* towerShieldCD;
    CCSprite* towerShieldAlert;
    CCSprite* lastBird;
    BOOL isBlowBigEnabled;
    BOOL isBlowBigCoolDown;
    BOOL isTowerShieldCoolDown;
    int blowBigCount;
    NSMutableArray* birds;
    NSMutableArray* pigs;
    Bird* currentBird;
    Pig* currentPig;
    BOOL gameStart;
    BOOL gameFinish;
    BOOL birdWin;
    BOOL pigWin;
    slingShot* ss;
    int touchStatus;
    int leftBirdNum;
    int leftPigNum;
    //定义一个世界
    b2World* world;
    //碰撞事件监听对象
    myContactListener* contactListener;
    BOOL trans2GameFinish;
    CCLabelTTF* leftPigNumLabel;
    CCLabelTTF* leftBirdNumLabel;
}
+ (id)scene;
+ (id)sceneWithLevel:(int) level;
- (id)initWithLevel:(int) level;

@end
