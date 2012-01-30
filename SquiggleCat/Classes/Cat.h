//
//  Cat.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Cat : CCNode {

    CCSprite *spriteBody_;
    
    CCSprite *spriteEye_;
    
    CCSprite *spriteTail_;

    CCAction *walkAnimation_;
    
    CCAction *surprisedAnimation_;
    
    CCAction *hurtFaceAnimation_;    
    
    CGRect boundingBox_;
    
    CGPoint moveTarget_;
}

@property (nonatomic, readonly) CGRect boundingBox;
@property (nonatomic, assign) CGPoint moveTarget;

+ (id) cat;

- (id) initCat;

- (void) initAnimations;

- (void) runTailAnimation;

- (void) runWalkAction;

- (CGRect) boundingBoxInWorldCoord;

- (void) walkTo:(CGPoint)pos;

- (void) fatten;

- (void) slim;

- (void) moveTowards:(CGPoint)pos;

@end
