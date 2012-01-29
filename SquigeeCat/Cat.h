//
//  Cat.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 22/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameObjects.h"

#define DEBUG_BOUNDINGBOX 1


typedef enum {
    kCatStateIdle,
    kCatStateWalk,
    kCatStateOuch,
    kCatStateHappy,
} CatState;

@interface Cat : GameObjects {
    CCSprite *sprite_;
    CCSprite *spriteEye_;
    CCSprite *spriteTail_;
    CGRect rect_;    
    CCAction *walkAnimation_;
    CCAction *surprisedAnimation_;
    CCAction *hurtFaceAnimation_;

	CatState state;
}
@property (nonatomic, readonly) CGRect rect;
@property(nonatomic,assign) CatState state;
@property (nonatomic,retain) CCSprite *sprite_;
- (id)initWithPosition:(CGPoint)pos;
- (void)walk;
- (void)surprised;

@end