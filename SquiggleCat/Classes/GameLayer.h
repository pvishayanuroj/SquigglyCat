//
//  GameLayer.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ItemDelegate.h"

@class Cat;
@class Pair;
@class IncrementingText;
@class AnimatedButton;
@class Banners;

@interface GameLayer : CCLayer <ItemDelegate> {
    
    Cat *cat_;
    
    Banners *comboBanner_;
    
    IncrementingText *scoreText_;
    
    CCLabelBMFont *timerLabel_;    
    
    NSInteger timer_;
    
    NSMutableArray *items_;
    
    NSMutableSet *gridStatus_;
    
    NSInteger numGridsX_;
    
    NSInteger numGridsY_;  
    
    CGSize gridSize_;
    
    BOOL isCatFrozen_;
    
    BOOL clickEnabled_;
    
    AnimatedButton *pauseButton_;
}

- (void) addItem:(ItemType)itemType gridPos:(Pair *)gridPos;

- (Pair *) gridPosFromPos:(CGPoint)pos;

- (CGPoint) posFromGridPos:(Pair *)gridPos;

- (NSSet *) tilesTouchingCat;

- (void) endLevel;

- (void) pauseGame;

- (void) resumeGame;

- (void) freezeCat;

- (void) unfreezeCat;

@end
