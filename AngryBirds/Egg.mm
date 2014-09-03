//
//  Egg.m
//  AngryBirds
//
//  Created by Junwei Hu on 14-8-3.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "Egg.h"

@implementation Egg
-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    imageURL = @"pigKing";
    myLayer = layer;
    // myLayer表示 GameLayer游戏场景
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png",imageURL]];
    self.position = ccp(x, y);
    self.tag = EGG_ID;
    HP = 30;
    float scale = 4;
    
    self.scale = scale/10;
    
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    ballBodyDef.userData = self;
    
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
    myBody = ballBody;
    
    float size = 0.12f;
    b2PolygonShape blockShape;
    b2Vec2 vertices[] = {
        b2Vec2(size ,-2*size),
        b2Vec2(2*size,-size),
        b2Vec2(2*size,size),
        
        b2Vec2(size,2*size),
        b2Vec2(-size,2*size),
        b2Vec2(-2*size,size),
        b2Vec2(-2*size,-size),
        b2Vec2(-size,-2*size)
    };
    blockShape.Set(vertices, 8);
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;
    ballShapeDef.density = 25.0f;
    ballShapeDef.friction = 80.0f; // We don't want the ball to have friction!
    ballShapeDef.restitution = 0.15f;
    ballBody->CreateFixture(&ballShapeDef);
//    b2BodyDef bodyAttr;
//    bodyAttr.type = b2_dynamicBody;
//    bodyAttr.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
//    bodyAttr.userData = self;
//    b2Body* body = world->CreateBody(&bodyAttr);
//    //设置物理上的一些属性
//    b2CircleShape shape;
//    shape.m_radius = 8.0f / PTM_RATIO;
//    b2FixtureDef fixtureAttr;
//    fixtureAttr.shape = &shape;
//    fixtureAttr.density = 10.0f;
//    fixtureAttr.friction = 0.1f;
//    fixtureAttr.restitution = 0.1f;
//    body->CreateFixture(&fixtureAttr);
    
    
    
    
    return self;
}

@end
