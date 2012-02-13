//
//  BoxDebugLayer.m
//
//  Created by John Wordsworth on 12/06/2011.
//

#import "BoxDebugLayer.h"

@implementation BoxDebugLayer

/** Create a debug layer with the given world and ptm ratio */
+(BoxDebugLayer *)debugLayerWithWorld:(b2World *)world ptmRatio:(int)ptmRatio 
{
    return [[[BoxDebugLayer alloc] initWithWorld:world ptmRatio:ptmRatio] autorelease];
}

/** Create a debug layer with the given world, ptm ratio and debug display flags */
+(BoxDebugLayer *)debugLayerWithWorld:(b2World *)world ptmRatio:(int)ptmRatio flags:(uint32)flags
{
    return [[[BoxDebugLayer alloc] initWithWorld:world ptmRatio:ptmRatio flags:flags] autorelease];
}

/** Create a debug layer with the given world and ptm ratio */
-(id)initWithWorld:(b2World*)world ptmRatio:(int)ptmRatio
{
    return [self initWithWorld:world ptmRatio:ptmRatio flags:b2DebugDraw::e_shapeBit];
}

/** Create a debug layer with the given world, ptm ratio and debug display flags */
-(id)initWithWorld:(b2World*)world ptmRatio:(int)ptmRatio flags:(uint32)flags
{
	if ((self = [self init])) {
		_boxWorld = world;
        _ptmRatio = ptmRatio;
		_debugDraw = new GLESDebugDraw( ptmRatio );
        
		_boxWorld->SetDebugDraw(_debugDraw);
		_debugDraw->SetFlags(flags);		
	}
	
	return self;    
}

/** Clean up by deleting the debug draw layer. */
-(void)dealloc
{
	_boxWorld = NULL;
	
	if ( _debugDraw != NULL ) {
		delete _debugDraw;
	}
	
	[super dealloc];
}
 

/** Tweak a few OpenGL options and then draw the Debug Layer */
-(void)draw	
{
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glPushMatrix();
	glScalef( CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1.0f);
	_boxWorld->DrawDebugData();
	glPopMatrix();	
	
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);	
}

@end
