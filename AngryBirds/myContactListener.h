//
//  myContactListener.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/11/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Box2D.h"
#import "cocos2d.h"
#import "SpriteBase.h"
#import "Bird.h"
#import "Pig.h"
#import "Ice.h"

class myContactListener : public b2ContactListener {
   
public:
    b2World* _world;
    CCLayer* _layer;
    myContactListener();
    myContactListener(b2World* w, CCLayer* c);
    ~myContactListener();
    virtual void BeginContact(b2Contact* contact);
    virtual void EndContact(b2Contact* contact);
    virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
    virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
    
    
    
};
