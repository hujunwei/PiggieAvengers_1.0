//
//  shortWood.m
//  Defend my eggs
//
//  Created by Junwei Hu on 14-8-17.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "ShortWood.h"

@implementation ShortWood

-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    imageURL = @"stone1";
    myLayer = layer;
    // myLayer表示 GameLayer游戏场景
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png",imageURL]];
    self.position = ccp(x, y);
    self.tag = SHORTWOOD_ID;
    HP = 10;
    float scale = 2;
    
    self.scale = scale/10;
    // Create ball body
//    b2BodyDef ballBodyDef;
//    ballBodyDef.type = b2_dynamicBody;
//    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
//    ballBodyDef.userData = self;
//    
//    b2Body * ballBody = world->CreateBody(&ballBodyDef);
//    
//    // Create block shape
//    b2PolygonShape blockShape;
//    blockShape.SetAsBox(self.contentSize.width/11/PTM_RATIO,self.contentSize.height/11/PTM_RATIO);
//    
//    // Create shape definition and add to body
//    b2FixtureDef ballShapeDef;
//    ballShapeDef.shape = &blockShape;
//    ballShapeDef.density = 02.0f;
//    ballShapeDef.friction = 1.0f; // We don't want the ball to have friction!
//    ballShapeDef.restitution = 0;
//    ballBody->CreateFixture(&ballShapeDef);
    
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
    ballShapeDef.density = 2.0f;
    ballShapeDef.friction = 80.0f; // We don't want the ball to have friction!
    ballShapeDef.restitution = 0.5f;
    ballBody->CreateFixture(&ballShapeDef);
    
   
    return self;
}



@end
