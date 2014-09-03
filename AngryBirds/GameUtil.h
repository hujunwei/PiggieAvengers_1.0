//
//  GameUtil.h
//  AngryBirds
//
//  Created by Junwei Hu on 7/1/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameUtil : NSObject
+ (int) readLevelFromFile;
+ (void) writeLevelToFile:(int) level;

@end
