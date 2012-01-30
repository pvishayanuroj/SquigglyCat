//
//  Item.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ItemDelegate.h"

@class Pair;

@interface Item : CCNode {
    
    CCSprite *sprite_;
    
    CGRect boundingBox_;
    
    ItemType itemType_;
    
    Pair *gridPos_;
    
    id <ItemDelegate> delegate_;
}

@property (nonatomic, assign) id <ItemDelegate> delegate;
@property (nonatomic, readonly) ItemType itemType;
@property (nonatomic, retain) Pair *gridPos;

- (void) collide;

- (void) spawnIn;

- (void) spawnOut;

- (CGRect) boundingBoxInWorldCoord;

@end
