//
//  Items.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 24/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObjects.h"
#define DEBUG_BOUNDINGBOX 1

@interface Items : GameObjects {
    CCSprite *sprite_;
    CGRect rect_;   
}
@property (nonatomic, readonly) CGRect rect;
@property (nonatomic, readonly) CCSprite *sprite_;
- (id)initWithPosition:(CGPoint)pos;
- (void)update:(ccTime)dt;

- (void)spawnIn;
- (void)spawnOut;

@end

