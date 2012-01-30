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

    CGRect boundingBox_;
}

@property (nonatomic, readonly) CGRect boundingBox;

+ (id) cat;

- (id) initCat;

- (CGRect) boundingBoxInWorldCoord;

@end
