//
//  BoxDebugLayer.h
//
//  Created by John Wordsworth on 12/06/2011.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

@interface BoxDebugLayer : CCLayer {
	GLESDebugDraw* _debugDraw;
	b2World *_boxWorld;
    int _ptmRatio;
}

/** Return an autoreleased debug layer */
+(BoxDebugLayer *)debugLayerWithWorld:(b2World *)world ptmRatio:(int)ptmRatio;
+(BoxDebugLayer *)debugLayerWithWorld:(b2World *)world ptmRatio:(int)ptmRatio flags:(uint32)flags;

/** Initialise a debug layer with the given parameters. */
-(id)initWithWorld:(b2World *)world ptmRatio:(int)ptmRatio;
-(id)initWithWorld:(b2World *)world ptmRatio:(int)ptmRatio flags:(uint32)flags;

@end