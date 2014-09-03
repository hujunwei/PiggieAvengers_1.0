//
//  myContactListener.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/11/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "myContactListener.h"

myContactListener :: myContactListener() {
    
}
myContactListener :: myContactListener(b2World *w, CCLayer *c) {
    _world = w;
    _layer = c;
}
myContactListener :: ~myContactListener() {
    
}

void myContactListener :: BeginContact(b2Contact *contact) {
    
}
void myContactListener:: EndContact(b2Contact *contact) {
    
}
void myContactListener:: PreSolve(b2Contact *contact, const b2Manifold *oldManifold) {
    
}
void myContactListener:: PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) {
    float force = impulse->normalImpulses[0];
    if (force > 2) {
        SpriteBase* spriteA = (SpriteBase*) contact->GetFixtureA()->GetBody()->GetUserData();
        SpriteBase* spriteB = (SpriteBase*) contact->GetFixtureB()->GetBody()->GetUserData();
        if (spriteA && spriteB) {
            if (spriteA.tag == BIRD_ID) {
                Bird* bird = (Bird*) spriteA;
                [bird hitAnimationX:bird.position.x andY:bird.position.y];
            }
            else {
                [spriteA setHP:(spriteA.HP - force)];
            }
            //鸟鸟相撞
            if (spriteB.tag == BIRD_ID) {
                Bird* bird = (Bird*) spriteB;
                [bird hitAnimationX:bird.position.x andY:bird.position.y];
            }
            else {
                [spriteB setHP:(spriteB.HP - force)];
            }
            //鸟猪相撞
            if ( (spriteA.tag == PIG_ID && spriteB.tag == BIRD_ID) || (spriteA.tag == BIRD_ID && spriteB.tag == PIG_ID) ){
                
                Pig* pig = (Pig*) spriteB;
                CCLabelBMFont* score = [CCLabelBMFont labelWithString:@"Good Job!" fntFile:@"konqa32.fnt"];
                score.scale = 0.2;
                score.position = spriteA.position;
                ccColor3B color0 = ccc3(240, 0, 0);
                ccColor3B color1 = ccc3(0, 240, 0);
                ccColor3B color2 = ccc3(240, 240, 0);
                int colorIX = arc4random() % 3;
                if (colorIX == 0) {
                    score.color = color0;
                }
                else if (colorIX == 1) {
                    score.color = color1;
                }
                else {
                    score.color = color2;
                }
                id action1 = [CCScaleTo actionWithDuration:0.25f scale:0.6];
                id action2 = [CCScaleBy actionWithDuration:0.5f scale:0];
                [score runAction:[CCSequence actions:action1,action2, nil]];
                [_layer addChild:score];
                [pig hitAnimationX:pig.position.x andY:pig.position.y];
            }
            else {
                [spriteB setHP:(spriteB.HP - force)];
            }
            //鸟墙相撞
            if (spriteB.tag == ICE_ID) {
                //Ice* ice = (Ice*) spriteB;
                //[ice hitAnimationX:ice.position.x andY:ice.position.y];
            }
            else {
                [spriteB setHP:(spriteB.HP - force)];
            }
            
           
            

        }
        
    }
    
}

