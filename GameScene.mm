//
//  GameScene.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/1/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "GameScene.h"
#import "cocos2d.h"
#import "JsonParser.h"



#define SLINGSHOT_POS CGPointMake(85, 125)

@implementation GameScene
+ (id)scene
{
    CCScene* sc = [CCScene node];
    GameScene* gs = [[GameScene alloc] init];
    [sc addChild:gs];
    [gs release];
    return sc;
}


+ (id)sceneWithLevel:(int)level
{
    CCScene* sc = [CCScene node];
    GameScene* gs = [GameScene nodeWithLevel:level];
    [sc addChild:gs];
    return sc;
}

+ (id)nodeWithLevel:(int)level
{
    return [[[self alloc] initWithLevel:level] autorelease];
}

- (id)initWithLevel:(int)level
{
    self = [super init];
    if (self) {
        isBlowBigEnabled = false;
        isBlowBigCoolDown = false;
        isTowerShieldCoolDown = false;
        trans2GameFinish = false;
        numWaves = 2 * level;
        totalNumWaves = numWaves;
        leftBirdNum = 4 * numWaves;
        leftPigNum = 4 * numWaves;
        currentLevel = level;
        gameReadyCount = 4;
        blowBigCount = 3;
        //GameScene先上背景
        bgSprite = [CCSprite spriteWithFile:@"gameBG@2x.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        bgSprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprite];
        //加雪花效果
        CCParticleSystem *snow = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeSnow];
        [self addChild:snow];
        //left number  of pig Label
        NSString* leftPigNumStr = [NSString stringWithFormat:@"LEFT PIG : %d", leftPigNum];
        leftPigNumLabel = [CCLabelTTF labelWithString:leftPigNumStr fontName:@"Abduction" fontSize:12];
        leftPigNumLabel.color = ccc3(0, 200, 0);
        leftPigNumLabel.position = ccp(400, 300);
        [self addChild:leftPigNumLabel];
        //right number of bird label
        NSString* leftBirdNumStr = [NSString stringWithFormat:@"LEFT BIRD WAVES: %d", numWaves - 1];
        leftBirdNumLabel = [CCLabelTTF labelWithString:leftBirdNumStr fontName:@"Abduction" fontSize:12];
        leftBirdNumLabel.color = ccc3(200, 0, 0);
        leftBirdNumLabel.position = ccp(80, 300);
        [self addChild:leftBirdNumLabel];
        //左右两个弹弓
        CCSprite* leftShot = [CCSprite spriteWithFile:@"leftshot.png"];
        [leftShot setScale:1.2f];
        leftShot.position = ccp(85, 110);
        [self addChild:leftShot];
        
        CCSprite* rightShot = [CCSprite spriteWithFile:@"rightshot.png"];
        rightShot.position = ccp(85, 110);
        [rightShot setScale:1.2f];
        [self addChild:rightShot];
        
        
        //大炮
        /*
         bigGun = [CCSprite spriteWithFile:@"dapao_new.png"];
         bigGun.position = ccp(380, 98);
         bigGun.scale = 0.5f;
         [self addChild:bigGun];
         */
        
        /*
         bigGun = [[BigGun alloc] initWithX:380 andY:98 andWorld:world andLayer:self];
         [self addChild:bigGun];
         */
        
        //rampage button
        rampageButton = [CCSprite spriteWithFile:@"blowbig.png"];
        [rampageButton setScale:0.15f];
        [rampageButton setPosition:ccp(115.0f, 30.0f)];
        [self addChild:rampageButton z:0];
        
        //shieldskill button
        shieldSkillButton = [CCSprite spriteWithFile:@"shieldskill.png"];
        [shieldSkillButton setPosition:ccp(55.0f, 32.0f)];
        [shieldSkillButton setScale:0.12f];
        [self addChild:shieldSkillButton];
        ss = [[slingShot alloc] init];
        ss._startPoint1 = ccp(82, 130);
        ss._startPoint2 = ccp(92, 128);
        ss._endPoint = SLINGSHOT_POS;
        ss.contentSize = CGSizeMake(480, 320);
        ss.position = ccp(240, 160);
        [self addChild:ss];
        //把标准触摸打开
        self.isTouchEnabled = YES;
        //注册cocos2d特有的方法, 当有时间的时候，会调用cctouchBegin， move， end等
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        [self createWorld];
        [self createLevel];
        [self schedule:@selector(drawLine:) interval:1 / 1200.0f];
    }
    return self;
}


- (void) drawLine:(id) args {
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
        if (b->GetUserData() != NULL) {
            SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
            //getUserdata其实就是得到一个cocos2d上与刚体对应的精灵, 一个刚体对应一个精灵
            if (oneSprite == lastBird ) {
                oneSprite.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                if (oneSprite.position.x < SLINGSHOT_POS.x && oneSprite.position.y < SLINGSHOT_POS.y) {
                    ss._endPoint = oneSprite.position;
                }
                else {
                    ss._endPoint = SLINGSHOT_POS;
                    lastBird = nil;
                }
            }
            else if (currentBird == nil && lastBird == nil){
                ss._endPoint = SLINGSHOT_POS;
            }
        }
    }
}


- (void) createWorld {
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    //设置世界的x，y上的加速度
    b2Vec2 gravity;
    gravity.Set(0.0f, -5.0f);
    //创建一个世界，如果世界中没有运动的物体，就停止模拟
    bool doSleep = true;
    world = new b2World(gravity, doSleep);
    
    //给world设置碰撞监听对象
    contactListener = new myContactListener(world, self);
    world->SetContactListener(contactListener);
    
    //创建地板刚体
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0, 0);
    b2Body* groundBody = world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    // PTM_RATIO = 32 表示每32个点表示1m，用起点和终点
    groundBox.SetAsEdge(b2Vec2(0,(float)87/PTM_RATIO), b2Vec2(screenSize.width/PTM_RATIO,(float)87/PTM_RATIO));
    groundBody->CreateFixture(&groundBox,0);
    //创建右侧城堡外刚体
    b2BodyDef rightWallBodyDef;
    rightWallBodyDef.position.Set(2/PTM_RATIO, 0);
    b2Body* rightWallBody = world->CreateBody(&rightWallBodyDef);
    b2PolygonShape rightWallBox;
    rightWallBox.SetAsEdge(b2Vec2( (float)(screenSize.width)/PTM_RATIO, 0), b2Vec2( (float)(screenSize.width)/PTM_RATIO, (float)((float)190)/PTM_RATIO) );
    rightWallBody->CreateFixture(&rightWallBox, 0);
    //创建弹弓刚体
        b2BodyDef shooterBodyDef;
        shooterBodyDef.position.Set(0, 0);
        b2Body* shooterBody = world->CreateBody(&shooterBodyDef);
        b2PolygonShape shooterBox;
        shooterBox.SetAsEdge(b2Vec2((float)85/PTM_RATIO,(float)90/PTM_RATIO), b2Vec2((float)85/PTM_RATIO,(float)105/PTM_RATIO));
        shooterBody->CreateFixture(&shooterBox, 0);
    
    
    //启动一个定时器，每隔1 / 60.0f s调一次，让世界运行起来
    [self schedule:@selector(tick:) interval: 1 / 12000.0f];
    
    
}

-(void) checkFinish:(id)args
{
    /* birdWin means the pig king was defeated */
    if (birdWin) {
        CCScene* gfs = [BirdWinGameFinishScene sceneWithLevel:currentLevel];
        CCTransitionScene* trans = [[CCTransitionFadeUp alloc] initWithDuration:0.5f scene:gfs];
        [[CCDirector sharedDirector] replaceScene:trans];
        [self unschedule:@selector(checkFinish:)];
    }
    else {
        if (leftBirdNum == 0){
            CCScene* gfs = [PigWinGameFinishScene sceneWithLevel:currentLevel];
            CCTransitionScene* trans = [[CCTransitionFadeUp alloc] initWithDuration:0.5f scene:gfs];
            [[CCDirector sharedDirector] replaceScene:trans];
            [self unschedule:@selector(checkFinish:)];
        }
    }
}


-(void) gameComplete
{
    trans2GameFinish = true;
    [self unschedule:@selector(tick:)];
    CCScene* gfs = [BirdWinGameFinishScene scene];
    CCTransitionScene* trans = [[CCTransitionFadeUp alloc] initWithDuration:0.5f scene:gfs];
    [[CCDirector sharedDirector] replaceScene:trans];
}


- (void)tick:(ccTime)dt
{
    //让世界往前模拟dt
    int32 velocityIterations = 8;
    int32 positionIterations = 6;
    world->Step(dt, velocityIterations, positionIterations);
    //更新cocos2d的界面，对所有的精灵刷新当前刚体运动的位置和角度
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
        if (b->GetUserData() != NULL) {
            SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
            //getUserdata其实就是得到一个cocos2d上与刚体对应的精灵, 一个刚体对应一个精灵
            oneSprite.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            //把box2d的角度改变成cocos2d中的角度
            if (oneSprite.tag != BIGGUN_ID) {
                oneSprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle() );
            }
            //如果小鸟停止运动删除小鸟
            if (oneSprite.tag == BIRD_ID ) {
                if (!b->IsAwake()|| oneSprite.position.x > 480 || oneSprite.position.y < 84 || oneSprite.position.x < 0 || oneSprite.position.y > 320|| oneSprite.HP < 0) {
                    world->DestroyBody(b);
                    [oneSprite destory];
                    [oneSprite removeFromParentAndCleanup:YES];
                    leftBirdNum--;
                }
            }
            
            if (oneSprite.tag == PIG_ID ) {
                if (!b->IsAwake()|| oneSprite.position.x > 480 || oneSprite.position.y < 84 || oneSprite.position.x < 0 || oneSprite.position.y > 320|| oneSprite.HP < 0) {
                    world->DestroyBody(b);
                    [oneSprite destory];
                    //[oneSprite removeFromParentAndCleanup:YES];
                }
            }
            
            if (oneSprite.tag == ICE_ID) {
                if (oneSprite.HP < 0) {
                    world->DestroyBody(b);
                    [oneSprite destory];
                    [oneSprite removeFromParentAndCleanup:YES];
                }
            }
            
            if (oneSprite.tag == EGG_ID) {
                if (oneSprite.HP < 15) {
                    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"sadPigKing.png"];
                    [oneSprite setScale:0.4f];
                    [oneSprite setTexture:tex];
                }
                
                if (oneSprite.HP < 0 || oneSprite.position.x > 480 || oneSprite.position.y < 84 || oneSprite.position.x < 0 || oneSprite.position.y > 320|| oneSprite.HP < 0) {
                    NSLog(@"HP: %f", oneSprite.HP);
                    world->DestroyBody(b);
                    [oneSprite destory];
                    [oneSprite removeFromParentAndCleanup:YES];
                    id actionShake = [CCShaky3D actionWithRange:10
                                                         shakeZ:NO
                                                           grid:ccg(5, 5)
                                                       duration:1.0f];
                    [bgSprite runAction:actionShake];
                    birdWin = true;
                    pigWin = false;
                }
            }
            
        }
    }
    /*
     if (birdWin || leftPigNum == 0) {
     //[self unschedule:@selector(tick:)];
     [self schedule:@selector(checkFinish:) interval:5.0f];
     }
     else if (leftBirdNum == 0) {
     pigWin = true;
     birdWin = false;
     //[self unschedule:@selector(tick:)];
     [self schedule:@selector(checkFinish:) interval:5.0f];
     }*/
    [self schedule:@selector(checkFinish:) interval:5.0f];
    
}





#define TOUCH_UNKNOW 0
#define TOUCH_SHOTBIRD 1

-(void) actionFinish:(CCNode*) currentNode
{
    CCParticleSystem* explosion = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
    [explosion setPosition:[currentNode position]];
    [self addChild:explosion];
    [currentNode removeFromParentAndCleanup:YES];
}


-(void) blowBigCoolUp:(id) args
{
    [blowBigCD removeFromParentAndCleanup:YES];
    CCTexture2D* texReady = [[CCTextureCache sharedTextureCache] addImage:@"blowbig.png"];
    [rampageButton setTexture:texReady];
    isBlowBigCoolDown = NO;
}

-(void) towerShieldCoolUpEnable:(id) args
{
    isTowerShieldCoolDown = NO;
    [towerShieldCD removeFromParentAndCleanup:YES];
    CCTexture2D* texReady = [[CCTextureCache sharedTextureCache] addImage:@"shieldskill.png"];
    [shieldSkillButton setTexture:texReady];
}

-(void) towerShieldCoolUp:(id) args
{
    [towerShieldAlert removeFromParentAndCleanup:YES];
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
        if (b->GetUserData() != NULL) {
            SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
            if (oneSprite.tag == ICE_ID) {
                NSString* str = [NSString stringWithFormat:@"stone.png"];
                CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                [oneSprite setTexture:tex];
                oneSprite.HP = 20;
            }
            if (oneSprite.tag == SHORTWOOD_ID) {
                NSString* str = [NSString stringWithFormat:@"stone1.png"];
                CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                [oneSprite setTexture:tex];
                oneSprite.HP = 20;
                
            }
            if (oneSprite.tag == LONGWOOD_ID) {
                NSString* str = [NSString stringWithFormat:@"stonelong1.png"];
                CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                [oneSprite setTexture:tex];
                oneSprite.HP = 20;
            }
            
        }
    }
}



- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    touchStatus = TOUCH_UNKNOW;
    CGPoint location = [self convertTouchToNodeSpace:touch];
    CGRect canTouchRect = CGRectMake(0, 0, 480, 320);
    
    
    
    /* scale up the tower */
    /*
     if (CGRectContainsPoint(piggieKing.boundingBox, location) ){
     //NSLog(@"is Touched");
     if (scaleUpButton == nil) {
     scaleUpButton = [CCSprite spriteWithFile:@"scaleUpButton.png"];
     [scaleUpButton setScale:0.5f];
     [scaleUpButton setPosition:ccp(piggieKing.position.x - 10, piggieKing.position.y + 10)];
     [self addChild:scaleUpButton];
     }
     
     }
     else {
     if (scaleUpButton != nil) {
     [scaleUpButton removeFromParentAndCleanup:YES];
     scaleUpButton = nil;
     }
     }
     
     if (scaleUpButton != nil && CGRectContainsPoint(scaleUpButton.boundingBox, location)) {
     for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
     if (b->GetUserData() != NULL) {
     SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
     if (oneSprite.tag == ICE_ID) {
     NSString* str = [NSString stringWithFormat:@"stone.png"];
     CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
     [oneSprite setTexture:tex];
     oneSprite.HP = 200;
     id actionShake = [CCShaky3D actionWithRange:1
     shakeZ:NO
     grid:ccg(1, 1)
     duration:1.0f];
     [oneSprite runAction:actionShake];
     if (scaleUpButton != nil) {
     [scaleUpButton removeFromParentAndCleanup:YES];
     scaleUpButton = nil;
     }
     }
     if (oneSprite.tag == SHORTWOOD_ID) {
     NSString* str = [NSString stringWithFormat:@"1.png"];
     CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
     //oneSprite.scale = 0.2f;
     [oneSprite setTexture:tex];
     oneSprite.HP = 200;
     id actionShake = [CCShaky3D actionWithRange:1
     shakeZ:NO
     grid:ccg(1, 1)
     duration:1.0f];
     [oneSprite runAction:actionShake];
     if (scaleUpButton != nil) {
     [scaleUpButton removeFromParentAndCleanup:YES];
     scaleUpButton = nil;
     }
     
     }
     if (oneSprite.tag == LONGWOOD_ID) {
     NSString* str = [NSString stringWithFormat:@"stonelong1.png"];
     CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
     //oneSprite.scale = 0.2f;
     [oneSprite setTexture:tex];
     oneSprite.HP = 200;
     id actionShake = [CCShaky3D actionWithRange:1
     shakeZ:NO
     grid:ccg(1, 1)
     duration:1.0f];
     [oneSprite runAction:actionShake];
     if (scaleUpButton != nil) {
     [scaleUpButton removeFromParentAndCleanup:YES];
     scaleUpButton = nil;
     }
     
     }
     
     }
     }
     
     }
     */
    //pig rampage
    if (CGRectContainsPoint(rampageButton.boundingBox, location) && blowBigCount > 0 && isBlowBigCoolDown == NO){
        //NSLog(@"is Touched");
        isBlowBigEnabled = true;
        //[currentPig setScale:3.0f];
        
        for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
            if (b->GetUserData() != NULL) {
                SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
                if (oneSprite.tag == PIG_ID && b->IsAwake()) {
                    //blowBig大招次数减1
                    blowBigCount--;
                    if (blowBigCount < 0) blowBigCount = 0;
                    [oneSprite setScale:2.5f];
                    oneSprite.HP = 200;
                    b2Fixture* f = b->GetFixtureList();
                    b2CircleShape* s = (b2CircleShape*)f->GetShape();
                    s->m_radius = 60.0f / PTM_RATIO;
                    f->SetDensity(50.0f);
                    id actionShake = [CCShaky3D actionWithRange:10
                                                         shakeZ:NO
                                                           grid:ccg(1, 1)
                                                       duration:1.0f];
                    [oneSprite runAction:actionShake];
                    isBlowBigCoolDown = YES;
                    
                }
            }
        }
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"blowBigCool.png"];
        [rampageButton setTexture:tex];
        blowBigCD = [CCProgressTimer progressWithFile:@"blowbig.png"];
        [blowBigCD setScale:0.15f];
        [blowBigCD setPosition:ccp(115.0f, 30.0f)];
        [blowBigCD setType:kCCProgressTimerTypeRadialCW];
        [self addChild:blowBigCD z:1];
        CCProgressTo* progressTo = [CCProgressTo actionWithDuration:5.0f percent:100.0f];
        [blowBigCD runAction:progressTo];
        [self performSelector:@selector(blowBigCoolUp:) withObject:nil afterDelay:5.0f];
    }
    //tower shield
    if (CGRectContainsPoint(shieldSkillButton.boundingBox, location) && isTowerShieldCoolDown == NO){
        towerShieldAlert = [CCSprite spriteWithFile:@"shield.png"];
        [towerShieldAlert setPosition:ccp(445.0f, 240.0f)];
        [towerShieldAlert setScale:0.3f];
        [self addChild:towerShieldAlert];
        CCScaleTo* actionScale = [CCScaleTo actionWithDuration:0.25f scale:0.5f];
        CCScaleTo* actionScale2 = [CCScaleTo actionWithDuration:0.25f scale:0.3f];
        CCSequence* sq = [CCSequence actions:actionScale, actionScale2, nil];
        CCRepeat* repeatScale = [CCRepeat actionWithAction:sq times:10];
        if (towerShieldAlert != nil) {
            [towerShieldAlert runAction:repeatScale];
        }
        
        for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
            if (b->GetUserData() != NULL) {
                SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
                if (oneSprite.tag == ICE_ID) {
                    NSString* str = [NSString stringWithFormat:@"ice.png"];
                    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                    [oneSprite setTexture:tex];
                    oneSprite.HP = 200;
                    b2Fixture* f = b->GetFixtureList();
                    f->SetDensity(40.0f);
                    f->SetFriction(20000.0f);
                    f->SetRestitution(0.0f);
                    isTowerShieldCoolDown = YES;
                }
                if (oneSprite.tag == SHORTWOOD_ID) {
                    NSString* str = [NSString stringWithFormat:@"littleice2.png"];
                    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                    //oneSprite.scale = 0.2f;
                    [oneSprite setTexture:tex];
                    b2Fixture* f = b->GetFixtureList();
                    f->SetDensity(40.0f);
                    oneSprite.HP = 200;
                    isTowerShieldCoolDown = YES;
                    
                }
                if (oneSprite.tag == LONGWOOD_ID) {
                    NSString* str = [NSString stringWithFormat:@"icelong.png"];
                    CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:str];
                    //oneSprite.scale = 0.2f;
                    b2Fixture* f = b->GetFixtureList();
                    f->SetDensity(40.0f);
                    [oneSprite setTexture:tex];
                    oneSprite.HP = 200;
                    isTowerShieldCoolDown = YES;
                }
                
            }
        }
        CCTexture2D* tex = [[CCTextureCache sharedTextureCache] addImage:@"shieldskillCool.png"];
        [shieldSkillButton setTexture:tex];
        towerShieldCD = [CCProgressTimer progressWithFile:@"shieldskill.png"];
        [towerShieldCD setScale:0.12f];
        [towerShieldCD setPosition:ccp(55.0f, 32.0f)];
        [towerShieldCD setType:kCCProgressTimerTypeVerticalBarBT];
        [self addChild:towerShieldCD z:1];
        CCProgressTo* progressTo = [CCProgressTo actionWithDuration:10.0f percent:100.0f];
        [towerShieldCD runAction:progressTo];
        [self performSelector:@selector(towerShieldCoolUp:) withObject:nil afterDelay:5.0f];
        [self performSelector:@selector(towerShieldCoolUpEnable:) withObject:nil afterDelay:10.0f];
    }
    
    if (CGRectContainsPoint(canTouchRect, location) && !gameFinish && !birdWin && !pigWin && leftPigNum > 0 && location.y > bigGun.position.y && location.x < bigGun.position.x) {
        touchStatus = TOUCH_SHOTBIRD;
        float x = (location.x - 380) * 50 / 70.0f;
        float y = (location.y - 125) * 50 / 70.0f;
        
        if (currentPig._isReady) {
            leftPigNum--;
            NSString* leftPigStr = [NSString stringWithFormat:@"LEFT PIG : %d", leftPigNum];
            id actionScale = [[CCScaleTo alloc] initWithDuration:0.2f scale:1.5f];
            id actionScale2 = [[CCScaleBy alloc]initWithDuration:0.2f scale:1 / 1.5f];
            CCSequence* allActions = [CCSequence actions:actionScale, actionScale2,  nil];
            [leftPigNumLabel setString:leftPigStr];
            [leftPigNumLabel runAction:allActions];
            //大炮设置角度
            CGFloat angleRadians = atanf((location.y - bigGun.position.y) / (location.x - bigGun.position.x));
            CGFloat angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
            //加上爆炸效果
            CCParticleSystem* explosion = [[ParticleManager sharedParticleManager] particleWithType:ParticleTypeBirdExplosion];
            [explosion setPosition:[currentPig position]];
            [self addChild:explosion];
            for (b2Body* b = world->GetBodyList(); b; b = b->GetNext() ) {
                if (b->GetUserData() != NULL) {
                    SpriteBase* oneSprite = (SpriteBase*)b->GetUserData();
                    //getUserdata其实就是得到一个cocos2d上与刚体对应的精灵, 一个刚体对应一个精灵
                    //oneSprite.position = CGPointMake(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
                    //把box2d的角度改变成cocos2d中的角度
                    //oneSprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle() );
                    //如果小鸟停止运动删除小鸟
                    if (oneSprite.tag == BIGGUN_ID ) {
                        oneSprite.rotation = -1 * angleDegrees - 30;
                    }
                    
                }
            }
            //bigGun.rotation = -1 * angleDegrees - 30;
            [currentPig setSpeedX:x andY:y andWorld:world];
            [self performSelector:@selector(jumpPig) withObject:nil afterDelay:0.1f];
            
        }
        
        
        return YES;
    }
    return NO;
}


//触摸过程中
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*
     if (touchStatus == TOUCH_SHOTBIRD) {
     CGPoint location = [self convertTouchToNodeSpace:touch];
     ss._endPoint = location;
     currentBird.position = location;
     }
     */
}

//计算斜率
- (CGFloat) getRatioFromPoint:(CGPoint)p1 toPoint:(CGPoint)p2
{
    return (p2.y - p1.y) / (p2.x - p1.x);
}

//触摸完之后
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    /*
     //弹弓复位，小鸟射出去
     if (touchStatus == TOUCH_SHOTBIRD) {
     CGPoint location = [self convertTouchToNodeSpace:touch];
     ss._endPoint = SLINGSHOT_POS;
     
     //        CGFloat r = [self getRatioFromPoint:location toPoint:SLINGSHOT_POS];
     //        //获得斜率
     //        CGFloat endX = 300;
     //        CGFloat endY = r * endX + location.y;
     //        CGPoint destPoint = ccp(endX, endY);
     //        CCMoveTo* moveAction = [[CCMoveTo alloc] initWithDuration:1.0f position:destPoint];
     //        [currentBird runAction:moveAction];
     //        [moveAction release];
     
     float x = (85.0f - location.x) * 50 / 70.0f;
     float y = (125.0f - location.y) * 50 / 70.0f;
     
     
     [currentBird setSpeedX:x andY:y andWorld:world];
     
     
     [birds removeObject:currentBird];
     currentBird = nil;
     [self performSelector:@selector(jump) withObject:nil afterDelay:2.0f];
     }*/
    touchStatus = TOUCH_UNKNOW;
    
}


- (void)createLevel
{
    
    NSString *s = [NSString stringWithFormat:@"2"];
    NSString *path = [[NSBundle mainBundle] pathForResource:s ofType:@"data"];
    NSLog(@"path is %@", path);
    NSArray *spriteArray = [JsonParser getAllSprite:path];
    
    // 从文件中读取初始位置
    
    for (spriteModel *sm in spriteArray) {
        switch (sm.tag) {
            case PIG_ID:
            {   /*
                 CCSprite *pig = [[Pig alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                 [self addChild:pig];
                 [pig release];
                 */
                break;
            }
            case ICE_ID:
            {
                CCSprite *ice = [[Ice alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:ice];
                [ice release];
                break;
            }
                
            case EGG_ID:
            {
                /* WARNING: NO RELEASE EGG HERE */
                CCSprite* egg = [[Egg alloc] initWithX:sm.x andY:sm.y andWorld:world andLayer:self];
                [egg.texture setAntiAliasTexParameters];
                [self addChild:egg];
                break;
            }
                
            case BIGGUN_ID:
            {
                bigGun = [[BigGun alloc] initWithX:sm.x andY:sm.y andWorld:world andLayer:self];
                [bigGun.texture setAntiAliasTexParameters];
                [self addChild:bigGun];
                break;
            }
                
            case SHORTWOOD_ID:
            {
                CCSprite *shortWood = [[ShortWood alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:shortWood];
                [shortWood release];
                break;
            }
                
            case LONGWOOD_ID:
            {
                CCSprite *longWood = [[LongWood alloc] initWithX:sm.x andY:sm.y andWorld:world  andLayer:self];
                [self addChild:longWood];
                [longWood release];
                break;
            }
            default:
                break;
        }
    }
    [self schedule:@selector(beginAlert:) interval:1.0f];
    [self performSelector:@selector(beginGame:) withObject:nil afterDelay:6.0f];
    
    
    
}
-(void) beginAlert:(id) args
{
    //倒计时
    if (gameReadyCount > 0) {
        NSString* waveStr = [NSString stringWithFormat:@"%d", gameReadyCount - 1];
        NSString* waveStr2 = [NSString stringWithFormat:@"Fire!"];
        CCLabelTTF* waveAlert = [CCLabelTTF labelWithString:waveStr fontName:@"Schwarzwald Regular" fontSize:56];
        [waveAlert setPosition:ccp(240, 200)];
        [waveAlert setColor:ccc3(240, 240, 0)];
        if (gameReadyCount == 1) {
            [waveAlert setString:waveStr2];
            //[waveAlert setColor:ccc3(0, 240, 0)];
        }
        id actionScale = [[CCScaleTo alloc] initWithDuration:1.0f scale:2.0f];
        id actionScale2 = [[CCScaleBy alloc] initWithDuration:0.0f scale:0];
        CCSequence* allActions = [CCSequence actions:actionScale, actionScale2,nil];
        [waveAlert runAction:allActions];
        [self addChild:waveAlert];
        [actionScale release];
        [actionScale2 release];
        gameReadyCount--;
    }
    else {
        [self unschedule:@selector(beginAlert:)];
    }
}

-(void) beginGame:(id) args
{
    //birds
    birds = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        Bird *bird = [[Bird alloc] initWithX:160 - i * 20 andY:93 andWorld:world andLayer:self];
        [bird.texture setAntiAliasTexParameters];
        [self addChild:bird];
        [birds addObject:bird];
        [bird release];
    }
    [self jump];
    
    //提示第几波
    NSString* waveStr = [NSString stringWithFormat:@"The 1th Wave!"];
    CCLabelTTF* waveAlert = [CCLabelTTF labelWithString:waveStr fontName:@"Scissor Cuts" fontSize:56];
    [waveAlert setPosition:ccp(240, 160)];
    [waveAlert setColor:ccc3(240, 240, 0)];
    id actionMove = [[CCMoveTo alloc] initWithDuration:2.0f position:ccp(240, 400)];
    id actionScale = [[CCScaleTo alloc] initWithDuration:2.0f scale:4.0f];
    CCSequence* allActions = [CCSequence actions:actionMove, actionScale, nil];
    [waveAlert runAction:allActions];
    [actionScale release];
    [actionMove release];
    [self addChild:waveAlert];
    
    [self schedule:@selector(birdFlyStart) interval:2.0f];
    numWaves--;
    
    //pigs
    pigs = [[NSMutableArray alloc] init];
    for (int i = 0; i < leftBirdNum; i++) {
        Pig *pig = [[Pig alloc] initWithX:320 andY:93 andWorld:world andLayer:self];
        //[self addChild:pig];
        [pig.texture setAntiAliasTexParameters];
        [pigs addObject:pig];
        [pig release];
    }
    [self jumpPig];
    [self schedule:@selector(initialBirdsAndPigs:) interval:15.0f];
}



-(void) initialBirdsAndPigs:(id)args
{
    //birds
    //count++;
    if (numWaves > 0 && !birdWin && !pigWin) {
        //提示第几波
        NSString* waveStr = [NSString stringWithFormat:@"The %dth Wave!", totalNumWaves - numWaves + 1];
        CCLabelTTF* waveAlert = [CCLabelTTF labelWithString:waveStr fontName:@"Scissor Cuts" fontSize:56];
        [waveAlert setPosition:ccp(240, 160)];
        [waveAlert setColor:ccc3(240, 240, 0)];
        id actionMove = [[CCMoveTo alloc] initWithDuration:2.0f position:ccp(240, 400)];
        id actionScale = [[CCScaleTo alloc] initWithDuration:2.0f scale:4.0f];
        CCSequence* allActions = [CCSequence actions:actionMove, actionScale, nil];
        [waveAlert runAction:allActions];
        [actionScale release];
        [actionMove release];
        [self addChild:waveAlert];
        
        birds = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            Bird *bird = [[Bird alloc] initWithX:160 - i * 20 andY:93 andWorld:world andLayer:self];
            [self addChild:bird];
            [birds addObject:bird];
            [bird release];
        }
        //开始加载一波鸟
        [self jump];
        [self schedule:@selector(birdFlyStart) interval:3.0f];
        
        /*
         //pigs
         pigs = [[NSMutableArray alloc] init];
         for (int i = 0; i < 4; i++) {
         Pig *pig = [[Pig alloc] initWithX:320 + i * 20 andY:93 andWorld:world andLayer:self];
         [self addChild:pig];
         [pigs addObject:pig];
         [pig release];
         }
         [self jumpPig];
         */
        numWaves--;
        //set left num of birds
        NSString* leftBirdStr = [NSString stringWithFormat:@"LEFT BIRD WAVES: %d", numWaves];
        id actionScale1 = [[CCScaleTo alloc] initWithDuration:0.2f scale:1.5f];
        id actionScale2 = [[CCScaleBy alloc]initWithDuration:0.2f scale:1 / 1.5f];
        CCSequence* allActions1 = [CCSequence actions:actionScale1, actionScale2, nil];
        [leftBirdNumLabel setString:leftBirdStr];
        [leftBirdNumLabel runAction:allActions1];
        
    }
    else {
        [self unschedule:@selector(initialBirdsAndPigs:)];
    }
}

-(void)jump
{
    if (birds.count > 0 && !gameFinish && !birdWin && !pigWin) {
        currentBird = [birds objectAtIndex:0];
        CCJumpTo* action = [[CCJumpTo alloc] initWithDuration:1 position:ccp(85, 125) height:50 jumps:1];
        CCCallBlockN* jumpFinish = [[CCCallBlockN alloc] initWithBlock:^(CCNode *node) {
            currentBird._isReady = YES;
            gameStart = YES;
        }];
        CCSequence* allActions = [CCSequence actions:action, jumpFinish, nil];
        [action release];
        [jumpFinish release];
        [currentBird runAction:allActions];
    }
}


-(void)jumpPig
{
    if (pigs.count > 0 && !gameFinish && !birdWin && !pigWin) {
        currentPig = [pigs objectAtIndex:0];
        [currentPig setScale:0.05f];
        [self addChild:currentPig];
        CCScaleTo* actionScale = [[CCScaleTo alloc] initWithDuration:0.3f scale:0.3f];
        CCScaleBy* actionScale2 = [[CCScaleBy alloc] initWithDuration:0.3f scale:1.3f];
        CGFloat angle = bigGun.rotation + 30;
        CGFloat radian = CC_DEGREES_TO_RADIANS(angle);
        CGFloat offsetX = 22 * cosf(radian);
        
        CGFloat offsetY = 22 * sinf(radian) + 5;
        
        CGPoint pigJumpPoint = ccp(bigGun.position.x - offsetX, bigGun.position.y + offsetY);
        CCJumpTo* actionJump = [[CCJumpTo alloc] initWithDuration:0.4f position:pigJumpPoint height:50 jumps:1];
        
        CCCallBlockN* jumpFinish = [[CCCallBlockN alloc] initWithBlock:^(CCNode *node) {
            currentPig._isReady = YES;
            gameStart = YES;
        }];
        CCSequence* allActions = [CCSequence actions:actionScale, actionScale2, actionJump, jumpFinish, nil];
        [actionJump release];
        [jumpFinish release];
        
        [currentPig runAction:allActions];
        [pigs removeObject:currentPig];
    }
}



-(void)birdFlyStart
{
    if (birds.count > 0 && !gameFinish && !birdWin && !pigWin) {
        CGPoint location = ccp(arc4random() % 10 + 20, arc4random() % 10 + 90);
        printf("locationX is : %f, locationX is : %f\n", location.x, location.y);
        currentBird = [birds objectAtIndex:0];
        //ss._endPoint = location;
        currentBird.position = location;
        float x = (65.0f * (1 + (totalNumWaves - numWaves) * 0.2)- location.x) * 50 / 70.0f;
        float y = (125.0f - location.y) * 50 / 70.0f;
        [currentBird setSpeedX:x andY:y andWorld:world];
        //ss._endPoint = SLINGSHOT_POS;
        [birds removeObject:currentBird];
        lastBird = currentBird;
        currentBird = nil;
        [self performSelector:@selector(jump) withObject:nil afterDelay:0.5f];
    }
}


- (void)dealloc
{
    
    [super dealloc];
}


@end


