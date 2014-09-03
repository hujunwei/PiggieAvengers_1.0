//
//  PigWinGameFinishScene.h
//  AngryBirds
//
//  Created by Junwei Hu on 14-8-6.
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
#import "CongratulationScene.h"
@interface PigWinGameFinishScene : CCLayer
{
    CCLabelBMFont* loadingTitle;
    int currLevel;
}
+(id) scene;
+ (id)sceneWithLevel:(int) level;
- (id)initWithLevel:(int) level;

@end
