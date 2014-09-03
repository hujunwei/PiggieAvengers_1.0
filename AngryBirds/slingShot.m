//
//  slingShot.m
//  AngryBirds
//
//  Created by Junwei Hu on 7/10/14.
//  Copyright (c) 2014 Junwei Hu. All rights reserved.
//

#import "slingShot.h"

@implementation slingShot

@synthesize _startPoint1;
@synthesize _startPoint2;
@synthesize _endPoint;


- (void)draw
{
    glLineWidth(2.0f);
    glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
    glEnable(GL_LINE_SMOOTH);
    glDisable(GL_TEXTURE_2D);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glDisableClientState(GL_COLOR_ARRAY);
    //真正画线
    GLfloat ver[4] = {_startPoint1.x, _startPoint1.y, _endPoint.x, _endPoint.y };
    glVertexPointer( 2, GL_FLOAT, 0, ver);
    glDrawArrays(GL_LINES, 0, 2);
    
    GLfloat ver2[4] = {_startPoint2.x, _startPoint2.y, _endPoint.x, _endPoint.y };
    glVertexPointer( 2, GL_FLOAT, 0, ver2);
    glDrawArrays(GL_LINES, 0, 2);
    
    
    glEnableClientState(GL_COLOR_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnable(GL_TEXTURE_2D);
    
}
@end
