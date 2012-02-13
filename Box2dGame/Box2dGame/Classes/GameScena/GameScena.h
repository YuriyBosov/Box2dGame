//
//  GameScena.h
//  Box2dGame
//
//  Created by Yuriy Bosov on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "BoxDebugLayer.h"

@interface GameScena : CCLayer
{
    b2World *world;
    BoxDebugLayer *debugDraw;
}

+(CCScene *) scene;

@end
