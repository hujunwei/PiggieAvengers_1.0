//
//  GameFinishScene.h
//  AngryBirds
//
//  Created by Junwei Hu on 14-8-5.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
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
#import "GameScene.h"
#import "LevelScene.h"
@interface BirdWinGameFinishScene : CCLayer
{
    CCLabelBMFont* loadingTitle;
    int currLevel;
}
+(id) scene;
+ (id)sceneWithLevel:(int) level;
- (id)initWithLevel:(int) level;

@end
