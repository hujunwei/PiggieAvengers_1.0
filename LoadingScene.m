//
//  LoadingScene.m
//  AngryBirds
//
//  Created by Junwei Hu on 6/28/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "LoadingScene.h"
#import "StartScene.h"
@implementation LoadingScene


+(id)scene
{
    //创建一个空的剧场
    CCScene* sc = [CCScene node];
    //创建一个loading节目
    LoadingScene* ls = [LoadingScene node];
    //把我们的节目加上来
    [sc addChild:ls];
    return sc;
}





- (id)init
{
    self = [super init];
    if (self) {
        // 标准init方法
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        // 通过导演类CCDirector来获取屏幕的宽高
       
        CCSprite *sp = [CCSprite spriteWithFile:@"loading@2x.png"];
        // 创建了一个精灵对象，这个对象就是一张图片
        [sp setPosition:ccp(winSize.width/2.0f, winSize.height/2.0f)];
                // ccp = CGPointMake
        // 设置精灵的中心坐标
        [self addChild:sp];
        //创建title精灵
       
        CCLabelBMFont* title = [[CCLabelBMFont alloc] initWithString:@"Birds destroyed our home...\nso we now fight back !!!" fntFile:@"bitmapFontTest4.fnt"];
        [title setColor:ccc3(0, 240, 0)];
        [title setPosition:ccp(200, 250)];
        //[title setScale:0.5f];
        [self addChild:title];
       
        // 把精灵加入到self中 self就是节目
        loadingTitle = [[CCLabelBMFont alloc] initWithString:@"Loading" fntFile:@"arial16.fnt"];
        [loadingTitle setAnchorPoint:ccp(0.0f, 0.0f)];
        [loadingTitle setPosition:ccp(winSize.width - 80.0f, 10.0f)];
        [self addChild:loadingTitle];
        [self schedule:@selector(loadTick:) interval:1.0f];
        //每隔2.0f调用[self loadTick:]方法
        
        
    }
    return self;
}


- (void) loadTick: (double) dt
{
    static int count;
    count++;
    NSString* s = [NSString stringWithFormat:@"%@%@", [loadingTitle string], @"."];
    [loadingTitle setString:s];
    if (count > 4) {
        [self unscheduleAllSelectors];
        //Loading完成后上第二幕
        StartScene* startSC = [StartScene scene];
        CCTransitionScene* trans = [[CCTransitionJumpZoom alloc] initWithDuration:1.0f scene:startSC];
        [[CCDirector sharedDirector] replaceScene:trans];
    }
    
}

-(void)dealloc
{
    [loadingTitle release], loadingTitle = nil;
    [super dealloc];
}


@end
