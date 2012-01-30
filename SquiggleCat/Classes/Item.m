//
//  Item.m
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright 2012 Deloitte. All rights reserved.
//

#import "Item.h"


@implementation Item

const static CGFloat ITEM_FADE_IN_DURATION = 0.2f;
const static CGFloat ITEM_SCALE_UP_DURATION = 0.4f;
const static CGFloat ITEM_SCALE_DOWN_DURATION = 0.2f;

@synthesize delegate = delegate_;
@synthesize itemType = itemType_;
@synthesize gridPos = gridPos_;

+ (id) item
{
    NSAssert(NO, @"Cannot construct a generic item class");
    return nil;
}

- (id) initItem
{
    if ((self = [super init])) {
        
        gridPos_ = nil;
        sprite_ = nil;
        
    }
    return self;
}

- (void) dealloc
{
    [gridPos_ release];
    
    [super dealloc];
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (void) collide
{   
    [delegate_ itemCollided:self];
    [self spawnOut];
}

- (void) spawnIn 
{
    sprite_.scale = 0.1f;
    
    id fadeIn = [CCFadeIn actionWithDuration:ITEM_FADE_IN_DURATION];
    id scaleUp = [CCScaleTo actionWithDuration:ITEM_SCALE_UP_DURATION scale:1.0];
    [sprite_ runAction:[CCSequence actions:fadeIn, scaleUp, nil]];
}

- (void) spawnOut 
{   
    id scaleDown = [CCScaleTo actionWithDuration:ITEM_SCALE_DOWN_DURATION scale:0];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [sprite_ runAction:[CCSequence actions:scaleDown, done, nil]];
}

- (CGRect) boundingBoxInWorldCoord
{
    return CGRectMake(self.position.x + boundingBox_.origin.x, self.position.y + boundingBox_.origin.y, boundingBox_.size.width, boundingBox_.size.height);
}
            
#if DEBUG_BOUNDINGBOX
- (void) draw
{
    // top left
    CGPoint p1 = ccp(boundingBox_.origin.x - boundingBox_.size.width / 2, boundingBox_.origin.y + boundingBox_.size.height / 2);
    // top right
    CGPoint p2 = ccp(boundingBox_.origin.x + boundingBox_.size.width / 2, boundingBox_.origin.y + boundingBox_.size.height / 2);
    // bottom left
    CGPoint p3 = ccp(boundingBox_.origin.x - boundingBox_.size.width / 2, boundingBox_.origin.y - boundingBox_.size.height / 2);
    // bottom right
    CGPoint p4 = ccp(boundingBox_.origin.x + boundingBox_.size.width / 2, boundingBox_.origin.y - boundingBox_.size.height / 2);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);    
}
#endif

@end
