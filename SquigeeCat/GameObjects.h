//
//  GameObjects.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 22/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameObjects : CCNode {
        CCSpriteBatchNode *spriteSheet;
        BOOL isHit;
        BOOL isOktoRemove;
        int gridLocX;
        int gridLocY;
}
@property (nonatomic) BOOL isHit;
@property (nonatomic) BOOL isOktoRemove;
@property (nonatomic) int gridLocX;
@property (nonatomic) int gridLocY;
- (CGRect) Rect;

@end
