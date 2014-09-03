//
//  ParticleManager.h
//  AngryBirds
//
//  Created by Junwei Hu on 6/30/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ParticleManager : NSObject

typedef enum {
    ParticleTypeSnow,
    ParticleTypeBirdExplosion,
    ParticleTypeMax
}ParticleTypes;

+ (id)sharedParticleManager; //取得单例
- (CCParticleSystem* ) particleWithType: (ParticleTypes) type;

 
@end
