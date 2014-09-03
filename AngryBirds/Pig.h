//
//  Pig.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/9/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "SpriteBase.h"
#import <Foundation/Foundation.h>
#import "Box2D.h"
@interface Pig : SpriteBase
{
    BOOL _isReady;
    BOOL _isFly;
    b2World* _world;
}
@property (nonatomic, assign) BOOL _isFly;
@property (nonatomic, assign) BOOL _isReady;

-(void) setSpeedX:(float) x andY:(float) y andWorld:(b2World*) world;
-(void) hitAnimationX:(float) x andY:(float) y;





@end
