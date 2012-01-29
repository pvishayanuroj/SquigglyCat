//
//  GameLayer.h
//  SquigeeCat
//
//  Created by Dan Boriboon on 21/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DataManager.h"

#define GRID_X 6
#define GRID_Y 6
#define GRIDxSize 240/GRID_X;
#define GRIDySize 320/GRID_Y;

@class Cat;
@class Fish;
@class TrashCan;
@class Milk;
@class Litterbox;
@class Teddy;
@class AnimatedButton;

@interface GameLayer : CCLayer {
    CCSpriteBatchNode *spriteSheet;
    
    Cat *player;
    Fish *fish;
    TrashCan *trashcan;
    Milk *milk;
    Litterbox *litterbox;
    Teddy *teddy;
    float Velocity;
    float timer;
    float timercounter;
    float score;
    
    CCSprite *title;
    AnimatedButton *instructions;

    AnimatedButton *startButton;
    AnimatedButton *helpButton;
    AnimatedButton *highScoreButton;
    
    DataManager *datamanager;
    
    CCLabelBMFont *highscoreLabel_;
    CCLabelBMFont *timerLabel_;
    
    CCAction *_walkAction;
    CCAction *_moveAction;
    BOOL _moving;
    BOOL startFlag_;
    
    NSString *FishID;
    
    NSMutableArray *Items_Fish;
    NSMutableArray *ItemsToDelete;
    
    NSMutableArray *Items_Trash;
    NSMutableArray *Items_Milk;
    NSMutableArray *Items_Litterbox;
    NSMutableArray *Items_Teddy;
    
    int Coord[GRID_X][GRID_Y];
 
}
+(CCScene *) scene;
@property  (nonatomic, retain) CCSprite *title;
@property  (nonatomic, retain) AnimatedButton *instructions;
@property (nonatomic, retain) Cat *player;

@property (nonatomic, retain) AnimatedButton *startButton;
@property (nonatomic, retain) AnimatedButton *helpButton;
@property (nonatomic, retain) AnimatedButton *highScoreButton;

@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *moveAction;
@property (nonatomic, readonly) NSMutableArray *Items_Fish;
@property (nonatomic, readonly) NSMutableArray *Items_Trash;
@property (nonatomic, readonly) NSMutableArray *Items_Milk;
@property (nonatomic, readonly) NSMutableArray *Items_Litterbox;
@property (nonatomic, readonly) NSMutableArray *Items_Teddy;

@property (nonatomic, readonly) NSMutableArray *ItemsToDelete;
@property (nonatomic, retain) DataManager *datamanager;

@end
