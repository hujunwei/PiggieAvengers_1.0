//
//  JsonParser.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/10/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>


//精灵的一个模型
@interface spriteModel : NSObject
{
    int tag;
    float x;
    float y;
    float angle;
}

@property (nonatomic, assign) int tag;
@property (nonatomic, assign) float x;
@property (nonatomic, assign) float y;
@property (nonatomic, assign) float angle;


@end







@interface JsonParser : NSObject

+ (id)getAllSprite:(NSString*) file;

@end
