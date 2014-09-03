//
//  Slot.m
//  Defend my eggs
//
//  Created by Junwei Hu on 14-8-17.
//  Copyright (c) 2014年 Junwei Hu. All rights reserved.
//

#import "LongWood.h"

@implementation LongWood
-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    myLayer = layer;
    imageURL = @"stonelong1";
    HP = 10;
    fullHP = HP;
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png", imageURL]];
    self.position = ccp(x, y);
    float scale = 3.5;
    self.scale = scale / 10;
    self.tag = LONGWOOD_ID;
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    ballBodyDef.userData = self;
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
    // Create block shape
    b2PolygonShape blockShape;
    blockShape.SetAsBox(self.contentSize.width/7/PTM_RATIO,self.contentSize.height/6/PTM_RATIO);
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;
    ballShapeDef.density = 02.0f;
    ballShapeDef.friction = 3.0f;
    ballShapeDef.restitution = 0.40f;
    ballBody->CreateFixture(&ballShapeDef);

    
    return self;
}




@end
