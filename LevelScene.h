//
//  LevelScene.h
//  AngryBirds
//
//  Created by Junwei Hu on 6/30/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface LevelScene : CCLayer
{
    int successlevel;
    bool pigMode;
}
+(id) scene;

@end
