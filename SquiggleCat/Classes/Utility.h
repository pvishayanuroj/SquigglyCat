//
//  Utility.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Utility : NSObject {
    
}

+ (BOOL) intersects:(CGRect)a b:(CGRect)b;

+ (CGFloat) euclieanDistance:(CGPoint)a b:(CGPoint)b;

+ (BOOL) pointsEqual:(CGPoint)a b:(CGPoint)b;

+ (NSSet *) setIntersection:(NSSet *)a b:(NSSet *)b;

// a - b (All a not in b)
+ (NSSet *) setSubtraction:(NSSet *)a b:(NSSet *)b;

+ (NSObject *) randomObjectFromSet:(NSSet *)set;

+ (NSSet *) allGridTiles:(NSInteger)width height:(NSInteger)height;

@end
