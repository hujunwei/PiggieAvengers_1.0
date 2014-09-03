//
//  Ice.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/9/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "Ice.h"

@implementation Ice
-(id)initWithX:(float)x andY:(float)y andWorld:(b2World *)world andLayer:(CCLayer<SpriteDelegate> *)layer
{
    myWorld = world;
    myLayer = layer;
    imageURL = @"stone";
    HP = 10;
    fullHP = HP;
    self = [super initWithFile:[NSString stringWithFormat:@"%@.png", imageURL]];
    self.position = ccp(x, y);
    float scale = 2;
    self.scale = scale / 10;
    self.tag = ICE_ID;
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(x/PTM_RATIO, y/PTM_RATIO);
    ballBodyDef.userData = self;
    
    b2Body * ballBody = world->CreateBody(&ballBodyDef);
    
   // Create block shape
    b2PolygonShape blockShape;
    blockShape.SetAsBox(self.contentSize.width/11/PTM_RATIO,self.contentSize.height/11/PTM_RATIO);
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &blockShape;
    ballShapeDef.density = 05.0f;
    ballShapeDef.friction = 1.0f; // We don't want the ball to have friction!
    ballShapeDef.restitution = 0.23f;
    ballBody->CreateFixture(&ballShapeDef);
    
    return self;

}


-(void)hitAnimationX:(float)x andY:(float)y{
    for (int i = 0; i < 6; i++) {
        int range = 2;
        CCSprite *temp = [CCSprite spriteWithFile:@"littleice1.png"];
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
