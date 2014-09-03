//
//  slingShot.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/10/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "CCSprite.h"

@interface slingShot : CCSprite
{
    CGPoint _startPoint1;
    CGPoint _startPoint2;
    CGPoint _endPoint;
}

@property (nonatomic, assign) CGPoint _startPoint1;
@property (nonatomic, assign) CGPoint _startPoint2;
@property (nonatomic, assign) CGPoint _endPoint;

- (void)draw;
@end
