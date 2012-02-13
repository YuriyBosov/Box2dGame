//
//  GameScena.m
//  Box2dGame
//
//  Created by Yuriy Bosov on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameScena.h"
#import "Box2D.h"

#define PTM_RATIO 32.f
#define offset 25.f

// enums that will be used as tags
enum {
	kTagTileMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};

//==============================================================================
//==============================================================================
//==============================================================================
@interface GameScena ()

-(void) addNewSpriteWithCoords:(CGPoint)p;

@end

//==============================================================================
//==============================================================================
//==============================================================================

@implementation GameScena

//==============================================================================
+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    GameScena *gameMenu = [GameScena node];
    [scene addChild:gameMenu];
    return scene;
}

//==============================================================================
- (id) init
{
    self = [super init];
    if (self)
    {
        // enable touches
		self.isTouchEnabled = YES;
        
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // backround
        CCSprite *bg = [CCSprite spriteWithFile:@"bg.png"];
        bg.anchorPoint = ccp(0, 0);
        [self addChild:bg];
        
        // menu
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Back" fontName:@"HelveticaNeue" fontSize:10];
        CCMenuItemLabel *mil = [[[CCMenuItemLabel alloc] initWithTarget:self selector:@selector(back)] autorelease];
        mil.label = label;
        mil.color = ccWHITE;
        
        CGPoint position = CGPointMake(-screenSize.width/2 + mil.rect.size.width, screenSize.height/2 - mil.rect.size.height);
        mil.position = position;
        
        CCMenu *menu = [CCMenu menuWithItems:mil, nil];
        [self addChild:menu];
        
        // create world
        b2Vec2 gravity;
        gravity.Set(0.f, -10.f);
        
        world = new b2World(gravity, YES);
        world->SetContinuousPhysics(YES);
        
        //Создание тела земли
		b2BodyDef groundBodyDef;
		groundBodyDef.position.Set(0,0); // bottom-left corner
        b2Body* groundBody = world->CreateBody(&groundBodyDef);
		
		// Define the ground box shape.
		b2PolygonShape groundBox;		
                
        // bottom
		groundBox.SetAsEdge(b2Vec2(offset/PTM_RATIO,offset/PTM_RATIO), b2Vec2((screenSize.width - offset)/PTM_RATIO,offset/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);

		// right
		groundBox.SetAsEdge(b2Vec2((screenSize.width - offset)/PTM_RATIO,offset/PTM_RATIO), b2Vec2((screenSize.width - offset)/PTM_RATIO,(screenSize.height - offset)/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
        
        // top
		groundBox.SetAsEdge(b2Vec2(offset/PTM_RATIO,(screenSize.height - offset)/PTM_RATIO), b2Vec2((screenSize.width - offset)/PTM_RATIO,(screenSize.height - offset)/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
		
		// left
        groundBox.SetAsEdge(b2Vec2(offset/PTM_RATIO, (screenSize.height - offset)/PTM_RATIO), b2Vec2(offset/PTM_RATIO,offset/PTM_RATIO));
		groundBody->CreateFixture(&groundBox,0);
        
        [self schedule: @selector(tick:)];        
        
        // draw debug info
#ifdef DEBUG
        uint32 flags = b2DebugDraw::e_aabbBit | b2DebugDraw::e_centerOfMassBit | b2DebugDraw::e_jointBit | b2DebugDraw::e_pairBit | b2DebugDraw::e_shapeBit;
        [self addChild:[BoxDebugLayer debugLayerWithWorld:world ptmRatio:PTM_RATIO flags:flags] z:10000];
#endif
    }    
    return self;
}

//==============================================================================
- (void) dealloc
{
    delete world;
	world = NULL;
    
    [super dealloc];
}

//==============================================================================
- (void) back
{
    [[CCDirector sharedDirector] popScene];
}

//==============================================================================
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		[self addNewSpriteWithCoords: location];
	}
}

//==============================================================================
-(void) addNewSpriteWithCoords:(CGPoint)p
{
	CCSprite *sprite = [CCSprite spriteWithFile:@"body_01.png"];   
    [self addChild:sprite];
	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
    
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	bodyDef.userData = sprite;
	b2Body *body = world->CreateBody(&bodyDef);
    
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox((sprite.contentSize.width/PTM_RATIO)/2, (sprite.contentSize.height/PTM_RATIO)/2);
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;	
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}

//==============================================================================
-(void) tick: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
	
	//Iterate over the bodies in the physics world
	for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
	{
		if (b->GetUserData() != NULL) {
			//Synchronize the AtlasSprites position and rotation with the corresponding body
			CCSprite *myActor = (CCSprite*)b->GetUserData();
			myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
			myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
		}	
	}
}

@end
