//
//  GameScena.m
//  Box2dGame
//
//  Created by Yuriy Bosov on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScena.h"

@implementation GameScena

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameScena *gameMenu = [GameScena node];
    [scene addChild:gameMenu];
    return scene;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.anchorPoint = ccp(0, 0);
        [self addChild:bg];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Back" fontName:@"HelveticaNeue" fontSize:10];
        CCMenuItemLabel *mil = [[[CCMenuItemLabel alloc] initWithTarget:self selector:@selector(back)] autorelease];
        mil.label = label;
        mil.color = ccWHITE;
        
        CGPoint position = CGPointMake(size.width/2 - mil.rect.size.width, size.height/2 - mil.rect.size.height);
        mil.position = position;
        
        CCMenu *menu = [CCMenu menuWithItems:mil, nil];
        [self addChild:menu];
    }
    return self;
}

- (void) back
{
    [[CCDirector sharedDirector] popScene];
}

@end
