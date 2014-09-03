//
//  bigGun.m
//  AngryBirds
//
//  Created by Junwei Hu on 14-8-14.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "BigGun.h"

@implementation BigGun

-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    imageURL = @"dapao_new";
    myLayer = layer;
    // myLayer表示 GameLayer游戏场景
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png",imageURL]];
    self.position = ccp(x, y);
    self.tag = BIGGUN_ID;
    HP = 200000;
    float scale = 3;
    
    self.scale = scale/10;
    /*
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
    ballShapeDef.density = 2000000.0f;
    ballShapeDef.friction = 20000000.0f; // We don't want the ball to have friction!
    ballShapeDef.restitution = 0.15f;
    ballBody->CreateFixture(&ballShapeDef);*/
    
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
    fixtureAttr.density = 200000.0f;
    fixtureAttr.friction = 200000.0f;
    fixtureAttr.restitution = 0.2f;
    body->CreateFixture(&fixtureAttr);
    
    
    
    
    return self;
}
@end
