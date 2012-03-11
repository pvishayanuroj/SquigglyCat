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
#import "SimpleAudioEngine.h"

@interface Cat : CCNode {

    CCSprite *spriteBody_;
    
    CCSprite *spriteEye_;
    
    CCSprite *spriteTail_;
    
    //Body Animation

    CCAction *walkAnimation_;
    
    //Face Animations
    
    CCAction *hurtFaceAnimation_;
    
    CCAction *happyFaceAnimation_;
    
    CCAction *surprisedFaceAnimation_;
    
    CCAction *dizzyFaceAnimation_;
    
    CCAction *yummyFaceAnimation_;
    
    CCAction *poopFaceAnimation_;
    
    CCAction *sleepFaceAnimation_;
    
    //*****************
    
    CGRect boundingBox_;
    
    CGPoint moveTarget_;
    
    CGFloat velocity_;
    
    CGFloat milkCombo_;
    
    CGFloat milkyTimeMeter_;
    
    CGFloat bonusComboMeter_;
    
    CCParticleSystem *particle_;
}

@property (nonatomic, readonly) CGRect boundingBox;
@property (nonatomic, assign) CGPoint moveTarget;
@property (nonatomic) CGFloat milkyTimeMeter_;

+ (id) cat;

- (id) initCat;

- (void) initAnimations;

- (void) runTailAnimation;

- (void) catBreathing;

- (void) catCollide:(ItemType)itemType;

- (void) runWalkAction;

- (void) runHurtAnimation;

- (void) runHappyAnimation;

- (void) runSurprisedAnimation;

- (void) runDizzyAnimation;

- (void) runEatingAnimation;

- (void) runPoopAnimation;

- (void) endMilkyTime;

- (CGRect) boundingBoxInWorldCoord;

- (void) walkTo:(CGPoint)pos;

- (void) fatten;

- (void) slim;

- (void) moveTowards:(CGPoint)pos;

@end
