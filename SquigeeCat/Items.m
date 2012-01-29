//
//  Items.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Items.h"


@implementation Items
@synthesize rect = rect_, sprite_;

- (id)initWithPosition:(CGPoint)pos {
	if((self = [super init])){
        
        //Load Sprite
        sprite_ = [[CCSprite alloc] init];
        [self addChild:sprite_ z:5];
        self.position = pos;    
        
    }
	return self;
}


- (void) dealloc
{
    [sprite_ release];
    [super dealloc];
}
- (void)update:(ccTime)dt {
    
}

- (void)spawnIn {
    id action0 = [CCFadeIn actionWithDuration:0.2];
    id action1 = [CCScaleTo actionWithDuration:0 scale:0.1];
    id action2 = [CCScaleTo actionWithDuration:0.4 scale:1.0];
    id actionseq = [CCSequence actions:action1, action0, action2, nil];
    [sprite_ runAction:actionseq];
}

- (void)spawnOut {
    id action1 = [CCScaleTo actionWithDuration:0.2 scale:0];
    [sprite_ runAction:action1];
}


#if DEBUG_BOUNDINGBOX
- (void) draw
{
    // top left
    CGPoint p1 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // top right
    CGPoint p2 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y + rect_.size.height / 2);
    // bottom left
    CGPoint p3 = ccp(rect_.origin.x - rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);
    // bottom right
    CGPoint p4 = ccp(rect_.origin.x + rect_.size.width / 2, rect_.origin.y - rect_.size.height / 2);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);    
}
#endif
@end