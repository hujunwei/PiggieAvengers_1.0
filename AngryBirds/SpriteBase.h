//
//  SpriteBase.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/9/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

#define PTM_RATIO 32
#define BIRD_ID 1
#define PIG_ID 2
#define ICE_ID 3
#define EGG_ID 4
#define BIGGUN_ID 5
#define SHORTWOOD_ID 6
#define LONGWOOD_ID 7
@protocol SpriteDelegate;

@interface SpriteBase : CCSprite
{
    float HP;
    int fullHP;
    NSString* imageURL;
    CCLayer<SpriteDelegate>* myLayer;
    b2World* myWorld;
    b2Body* myBody;
}

@property (nonatomic, assign) float HP;
-(id)initWithX:(float) x andY:(float) y andWorld:(b2World*) world andLayer:(CCLayer<SpriteDelegate>*) layer;
-(void) destory;

@end

@protocol SpriteDelegate <NSObject>

-(void)sprite: (CCSprite*) sprite withScore:(int) score;

@end


