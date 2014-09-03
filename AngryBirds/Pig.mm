//
//  Pig.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/9/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "Pig.h"

@implementation Pig
@synthesize _isFly;
@synthesize _isReady;


-(id)initWithX:(float)x andY:(float)y andWorld:(b2World*)world andLayer:(CCLayer <SpriteDelegate> *)layer{
    myWorld = world;
    imageURL = @"pig";
    myLayer = layer;
    // myLayer表示 GameLayer游戏场景
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png", imageURL]];
    self.position = ccp(x, y);
    self.tag = PIG_ID;
    HP = 10;
    //self.scale = 4.0f;
    return self;
}

- (void) setSpeedX:(float)x andY:(float)y andWorld:(b2World *)world
{
    _world = world;
    /*
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    ballBodyDef.userData = self;
    
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
    //myBody = ballBody;
    
    float size = 10.0f;
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
    ballShapeDef.density = 80.0f;
    ballShapeDef.friction = 80.0f; // We don't want the ball to have friction!
    ballShapeDef.restitution = 0.15f;
    ballBody->CreateFixture(&ballShapeDef);
    */
    
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
    fixtureAttr.density = 10.0f;
    fixtureAttr.friction = 0.1f;
    fixtureAttr.restitution = 0.1f;
    body->CreateFixture(&fixtureAttr);
     
    
    
    //根据物理特性创建一个fixture；
    b2Vec2 force = b2Vec2(x, y);
    //给球的中心点一个力
    body->ApplyLinearImpulse(force, bodyAttr.position);
    
    
}

-(void)hitAnimationX:(float)x andY:(float)y{
    for (int i = 0; i < 6; i++) {
        int range = 2;
        CCSprite *temp = [CCSprite spriteWithFile:@"stone2.png"];
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
