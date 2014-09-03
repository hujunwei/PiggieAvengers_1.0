//
//  Bird.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/9/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "Bird.h"
#import "SpriteBase.h"
#import <Foundation/Foundation.h>

@implementation Bird
@synthesize _isFly;
@synthesize _isReady;

-(id)initWithX:(float) x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    myLayer = layer;
    imageURL = @"angrybirds3d";
    myWorld = world;
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png", imageURL]];
    //调用cocos2D里面创建精灵的方法
    self.tag = BIRD_ID;
    self.position = ccp(x,y);
    HP = 10;
    self.scale = 0.12f;
    return self;
}

- (void) setSpeedX:(float)x andY:(float)y andWorld:(b2World *)world
{
    _world = world;
    //给精灵创建一个b2body属性
    b2BodyDef bodyAttr;
    bodyAttr.type = b2_dynamicBody;
    bodyAttr.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    bodyAttr.userData = self;
    b2Body* body = world->CreateBody(&bodyAttr);
    //设置物理上的一些属性
    b2CircleShape shape;
    shape.m_radius = 10.0f / PTM_RATIO;
    b2FixtureDef fixtureAttr;
    fixtureAttr.shape = &shape;
    fixtureAttr.density = arc4random() % 5 + 13.0f;
    fixtureAttr.friction = 2.0f;
    fixtureAttr.restitution = 0.5f;
    body->CreateFixture(&fixtureAttr);
    //根据物理特性创建一个fixture；
    b2Vec2 force = b2Vec2(x, y);
    //给球的中心点一个力
    body->ApplyLinearImpulse(force, bodyAttr.position);
    
}

-(void)hitAnimationX:(float)x andY:(float)y{
    for (int i = 0; i < 6; i++) {
        int range = 2;
        
        CCSprite *temp = [CCSprite spriteWithFile:@"yumao1.png"];
        temp.scale = (float)(arc4random()%5/10.1f);
        
        temp.position = CGPointMake(x+arc4random()%10*range-10, y+arc4random()%10*range-10);
        id actionMove = [CCMoveTo actionWithDuration:1 position:CGPointMake(x+arc4random()%10*range-10, y+arc4random()%10*range-10)];
        
        id actionAlpha = [CCFadeOut actionWithDuration:1];
        id actionRotate = [CCRotateBy actionWithDuration:1 angle:arc4random()%180];
        id actionMoveEnd = [CCCallFuncN actionWithTarget:self selector:@selector(runEnd:)];
        
        id mut =[CCSpawn actions:actionMove,actionAlpha,actionRotate,nil];
        [temp runAction:[CCSequence actions:mut, actionMoveEnd,nil]];
        
        [myLayer addChild:temp];
    }
}




@end
