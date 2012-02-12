//
//  GameMenu.m
//  Box2dGame
//
//  Created by Yuriy Bosov on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameMenu.h"
#import "GameScena.h"

@implementation GameMenu

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameMenu *gameMenu = [GameMenu node];
    [scene addChild:gameMenu];
    return scene;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        CCSprite *bg = [CCSprite spriteWithFile:@"menu_bg.png"];
        bg.anchorPoint = ccp(0, 0);
        [self addChild:bg];
        
        CCLabelTTF *labelAtlas = [CCLabelTTF labelWithString:@"Go Game" fontName:@"HelveticaNeue-Bold" fontSize:30];
        labelAtlas.color = ccc3(50, 50, 50);
        CCMenuItemLabel *menuLabel = [[[CCMenuItemLabel alloc] initWithTarget:self selector:@selector(goGame)] autorelease];
        [menuLabel setLabel:labelAtlas];
        
        CCMenu *menu = [CCMenu menuWithItems:menuLabel, nil];
        [self addChild:menu];
    }
    return self;
}

- (void) goGame
{
    [[CCDirector sharedDirector] pushScene:[GameScena scene]];
}

@end
