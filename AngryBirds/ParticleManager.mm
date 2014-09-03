//
//  ParticleManager.m
//  AngryBirds
//
//  Created by Junwei Hu on 6/30/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "ParticleManager.h"

static ParticleManager *s;

@implementation ParticleManager
+ (id) sharedParticleManager
{
    if (s == nil) {
        s = [[ParticleManager alloc] init];
    }
    return s;
}


- (CCParticleSystem* ) particleWithType:(ParticleTypes)type
{
    CCParticleSystem* system = nil;
    switch (type) {
        case ParticleTypeSnow:
        {
            system = [CCParticleSnow node];
            //图片转换成纹理
            CCTexture2D* t = [[CCTextureCache sharedTextureCache] addImage:@"snow.png"];
            [system setTexture:t];
        }
            break;
        case ParticleTypeBirdExplosion:
            system = [ARCH_OPTIMAL_PARTICLE_SYSTEM particleWithFile:@"bird-explosion.plist"];
            [system setPositionType:kCCPositionTypeFree];
            [system setAutoRemoveOnFinish:YES];
            
            break;
        default:
            break;
    }
    return system;
}

@end
