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

@interface GameLayer : CCLayer <ItemDelegate> {
    
    Cat *cat_;
    
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
    
    AnimatedButton *restartButton_;
}

- (void) addItem:(ItemType)itemType gridPos:(Pair *)gridPos;

- (CGPoint) posFromGridPos:(Pair *)gridPos;

- (void) endLevel;

- (void) freezeCat;

@end
