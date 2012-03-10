//
//  Utility.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Utility.h"
#import "Pair.h"

@implementation Utility

static const CGFloat EPSILON = 0.001f;

+ (BOOL) intersects:(CGRect)a b:(CGRect)b
{
    // Top left
    CGPoint a1 = ccp(a.origin.x - a.size.width/2, a.origin.y + a.size.height/2);
    // Bottom right
    CGPoint a2 = ccp(a.origin.x + a.size.width/2, a.origin.y - a.size.height/2);    
    
    // Top left
    CGPoint b1 = ccp(b.origin.x - b.size.width/2, b.origin.y + b.size.height/2);
    // Bottom right
    CGPoint b2 = ccp(b.origin.x + b.size.width/2, b.origin.y - b.size.height/2);        
    
    return (a1.x < b2.x) && (a2.x > b1.x) && (a1.y > b2.y) && (a2.y < b1.y);
}

+ (CGFloat) euclieanDistance:(CGPoint)a b:(CGPoint)b
{
    return sqrt((a.x * b.x) + (a.y * b.y));
}

+ (BOOL) pointsEqual:(CGPoint)a b:(CGPoint)b
{
    return (fabs(a.x - b.x) < EPSILON && fabs(a.y - b.y) < EPSILON);
}

+ (NSSet *) setIntersection:(NSSet *)a b:(NSSet *)b
{
    NSMutableSet *set = [NSMutableSet setWithCapacity:[a count]];
    
    for (NSObject *obj in a) {
        if ([b containsObject:obj]) {
            [set addObject:obj];
        }
    }
    
    return set;
}

+ (NSSet *) setSubtraction:(NSSet *)a b:(NSSet *)b
{
    NSMutableSet *set = [NSMutableSet setWithCapacity:[a count]];
    
    for (NSObject *obj in a) {
        if (![b containsObject:obj]) {
            [set addObject:obj];
        }
    }
    
    return set;    
}

+ (NSObject *) randomObjectFromSet:(NSSet *)set
{
    if ([set count] > 0) {    
        NSInteger rand = arc4random() % [set count];
        NSInteger count = 0;
        for (NSObject *obj in set) {
            if (count == rand) {
                return obj;
            }
            count++;
        }
    }
    // Only gets here if empty set
    return nil;
}

+ (NSSet *) allGridTiles:(NSInteger)width height:(NSInteger)height
{
    NSMutableSet *set = [NSMutableSet setWithCapacity:width * height];
    
    for (NSInteger x = 0; x < width; ++x) {
        for (NSInteger y = 0; y < height; ++y) {
            [set addObject:[Pair pair:x second:y]];
        }
    }
    
    return set;
}

@end
