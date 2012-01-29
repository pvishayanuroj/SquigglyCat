//
//  GameLayer.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 21/1/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "Cat.h"
#import "Fish.h"
#import "TrashCan.h"
#import "Milk.h"
#import "Litterbox.h"
#import "Teddy.h"

#import "GameConfig.h"
#import "AnimatedButton.h"


@interface GameLayer (Private)
- (void)spawning;
@end

@implementation GameLayer
@synthesize player = _player;
@synthesize moveAction = _moveAction;
@synthesize title, instructions, startButton, helpButton, highScoreButton;
@synthesize walkAction = _walkAction;
@synthesize datamanager, Items_Fish, Items_Trash, Items_Milk, Items_Litterbox, Items_Teddy, ItemsToDelete;

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameLayer *layer = [GameLayer node];
	[scene addChild: layer];
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{   

	if( (self=[super init])) {
        
		self.isTouchEnabled = YES;
        srand(time(NULL)+rand()); //seed random with Time
#pragma mark - Initialize
        //Add background
        CCSprite *bg = [CCSprite spriteWithFile:@"background.png"];
		CGSize size = [[CCDirector sharedDirector] winSize];
		[bg setPosition:ccp(size.width/2, size.height/2)];
		[self addChild:bg z:-10];
        
        //Add Title
       
        title = [[CCSprite alloc] initWithFile:@"SquigeeHeader.png"];
        [title setPosition:ccp(size.width/2, size.height/2)];
        [self addChild:title z:20];
        
        instructions = [[AnimatedButton alloc] initButtonWithImage:@"SquigeeInstructions.png" target:self selector:@selector(moveHowToOut)];
        [instructions setPosition:ccp(640, size.height/2)];
        [self addChild:instructions z:21];
        
        startButton = [[AnimatedButton alloc] initButtonWithImage:@"StartButton.png" target:self selector:@selector(startGame)];
        helpButton = [[AnimatedButton alloc] initButtonWithImage:@"HowToButton.png" target:self selector:@selector(HowTo)];
        highScoreButton = [[AnimatedButton alloc] initButtonWithImage:@"HiScoresButton.png" target:self selector:@selector(HiScores)];
        
        startButton.position = CGPointMake(50, 200);
        helpButton.position = CGPointMake(100, 150);
        highScoreButton.position = CGPointMake(95, 100);        
        
        highscoreLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"Outline Font 28.fnt"] retain];
        highscoreLabel_.position = ccp(100,460);
        highscoreLabel_.scale = 0.8f;
        [self addChild:highscoreLabel_ z:15];
        
        timerLabel_ = [[CCLabelBMFont labelWithString:@"60" fntFile:@"Outline Font 28.fnt"] retain];
        timerLabel_.position = ccp(25,460);
        timerLabel_.scale = 1.0f;
        [self addChild:timerLabel_ z:15];
        
        
        [self addChild:startButton z:20];
        [self addChild:helpButton z:20];
        [self addChild:highScoreButton z:20]; 
        
        //Intialising Parameters
        datamanager.highscore =0;
        datamanager.gameFlag = 5;
        startFlag_ = NO;
        timer = 60;
        timercounter = 0;
        score = 0;
        
        
        //Initialize Player (Squigee Cat)
        player = [[Cat alloc] initWithPosition:ccp(100,200)];
		[self addChild:player z:1];
        
        for (int xcoord=0; xcoord<GRID_X;xcoord++){
            for(int ycoord=0; ycoord<GRID_Y; ycoord++){
                Coord[xcoord][ycoord]=0;
            }
        }
        
        
        //Initialise Objects
        Items_Fish = [[NSMutableArray alloc] init]; 
        Items_Trash = [[NSMutableArray alloc] init]; 
        Items_Milk = [[NSMutableArray alloc] init];
        Items_Litterbox = [[NSMutableArray alloc] init];
        Items_Teddy = [[NSMutableArray alloc] init];
        
        
        //Intialize Deleting Objects Array
        ItemsToDelete = [[NSMutableArray alloc] init];

        [self schedule:@selector(UpdateLoops:) interval:0.1f];
        [self schedule:@selector(Wave:) interval:3.0f];

	}
	return self;
}
#pragma mark - Start Buttons

-(void)startGame {
    CGSize size = [[CCDirector sharedDirector] winSize];
    id movetop = [CCMoveTo actionWithDuration:0.4 position:ccp(size.width/2,600)];
    id moveLeft1 =[CCMoveBy actionWithDuration:0.4 position:ccp(-500,0)];
    id moveLeft2 =[CCMoveBy actionWithDuration:0.4 position:ccp(-550,0)];
    id moveLeft3 =[CCMoveBy actionWithDuration:0.4 position:ccp(-545,0)];
    datamanager.gameFlag = 1;
    startFlag_ = YES;
    [title runAction:movetop];
    [startButton runAction:moveLeft1];
    [helpButton runAction:moveLeft2];
    [highScoreButton runAction:moveLeft3];
;
    
}

-(void)HowTo {
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveIn = [CCMoveTo actionWithDuration:0.4 position:ccp(size.width/2,size.height/2)];
	[instructions runAction:moveIn];
}

-(void)moveHowToOut {
    CGSize size = [[CCDirector sharedDirector] winSize];
    id moveIn = [CCMoveTo actionWithDuration:0.4 position:ccp(640,size.height/2)];
	[instructions runAction:moveIn];
}

-(void)HiScores {

	
	
}
-(void)stopMoving {
    id action1 = [CCMoveBy actionWithDuration:1 position:ccp(0,0)];
    [player runAction:action1];
}

#pragma mark - Update Loops
-(void) UpdateLoops: (id)sender {
    
#pragma mark - UpdateLabels
    [highscoreLabel_ setString:[NSString stringWithFormat:@"%0.0f", score]];
    
    if(timercounter == 10){
        timer--;
        timercounter = 0;
    }
    timercounter++;
    [timerLabel_ setString:[NSString stringWithFormat:@"%0.0f", timer]];
     
    
    
#pragma mark - Collision
    //****************************************************************
    //Detect Collision with Fish
    //****************************************************************
    for(fish in Items_Fish) {
        
        //defining the Collision Box with In-Game coordinates, the object's Rect is with respect to the object's coordinates
        CGRect fishRect = CGRectMake(fish.Rect.origin.x,
                                     fish.Rect.origin.y,
                                     fish.rect.size.width, 
                                     fish.rect.size.height);
        
        CGRect playerRect = CGRectMake(player.Rect.origin.x,
                                       player.Rect.origin.y,
                                       player.rect.size.width,
                                       player.rect.size.height);
        
        if(CGRectIntersectsRect(playerRect, fishRect)){
            Coord[fish.gridLocX][fish.gridLocY] =0;
            [fish spawnOut];
         //   [ItemsToDelete addObject:fish];
            
            //Add Score
            score+=100;
            
            //Get Fat
            if(player.sprite_.scale<=1.2){
            player.sprite_.scale+=0.1;
            }
                        
            NSLog(@"Hit Fish!");
        }
    
    
        for (fish in ItemsToDelete){
          //      [Items_Fish removeObject:fish];
                NSLog(@"cleaned up!");
                [self removeChild:fish cleanup:YES]; 
        }
    }
    //****************************************************************
    //Detect Collision with Trash Can
    //****************************************************************
    for(trashcan in Items_Trash) {
        
        //defining the Collision Box with In-Game coordinates, the object's Rect is with respect to the object's coordinates
        CGRect trashRect = CGRectMake(trashcan.Rect.origin.x,
                                     trashcan.Rect.origin.y,
                                     trashcan.rect.size.width, 
                                     trashcan.rect.size.height);
        
        CGRect playerRect = CGRectMake(player.Rect.origin.x,
                                       player.Rect.origin.y,
                                       player.rect.size.width,
                                       player.rect.size.height);
        
        if(CGRectIntersectsRect(playerRect, trashRect)){
            [trashcan crash];
            [player surprised];
           // [ItemsToDelete addObject:trashcan];
            NSLog(@"Hit! Trash");
        }
        
        
        for (trashcan in ItemsToDelete){
            // [Items_Fish removeObject:fish];
            //[self removeChild:trashcan cleanup:YES];
        }
    }
    //****************************************************************
    //Detect Collision with Milk
    //****************************************************************
    for(milk in Items_Milk) {
        
        //defining the Collision Box with In-Game coordinates, the object's Rect is with respect to the object's coordinates
        CGRect milkRect = CGRectMake(milk.Rect.origin.x,
                                      milk.Rect.origin.y,
                                      milk.rect.size.width, 
                                      milk.rect.size.height);
        
        CGRect playerRect = CGRectMake(player.Rect.origin.x,
                                       player.Rect.origin.y,
                                       player.rect.size.width,
                                       player.rect.size.height);
        
        if(CGRectIntersectsRect(playerRect, milkRect)){
            [milk spawnOut];
            // [ItemsToDelete addObject:trashcan];
            NSLog(@"Hit! Milk");
        }
        
        
        for (milk in ItemsToDelete){
            // [Items_Fish removeObject:fish];
            //[self removeChild:trashcan cleanup:YES];
        }
    }
    //****************************************************************
    //Detect Collision with Litterbox
    //****************************************************************
    for(litterbox in Items_Litterbox) {
        
        //defining the Collision Box with In-Game coordinates, the object's Rect is with respect to the object's coordinates
        CGRect litterboxRect = CGRectMake(litterbox.Rect.origin.x,
                                     litterbox.Rect.origin.y,
                                     litterbox.rect.size.width, 
                                     litterbox.rect.size.height);
        
        CGRect playerRect = CGRectMake(player.Rect.origin.x,
                                       player.Rect.origin.y,
                                       player.rect.size.width,
                                       player.rect.size.height);
        
        if(CGRectIntersectsRect(playerRect, litterboxRect)){
            [litterbox spawnOut];
            // [ItemsToDelete addObject:trashcan];
            NSLog(@"Hit! litterbox");
            
            //Get Thin
            if(player.sprite_.scale>1.0){
                player.sprite_.scale-=0.1;
            }
        }
        
        
        for (litterbox in ItemsToDelete){
            // [Items_Fish removeObject:fish];
            //[self removeChild:trashcan cleanup:YES];
        }
    }
    //****************************************************************
    //Detect Collision with Teddy
    //****************************************************************
    for(teddy in Items_Teddy) {
        //defining the Collision Box with In-Game coordinates, the object's Rect is with respect to the object's coordinates
        CGRect teddyRect = CGRectMake(teddy.Rect.origin.x,
                                          teddy.Rect.origin.y,
                                          teddy.rect.size.width, 
                                          teddy.rect.size.height);
        
        CGRect playerRect = CGRectMake(player.Rect.origin.x,
                                       player.Rect.origin.y,
                                       player.rect.size.width,
                                       player.rect.size.height);
        
        if(CGRectIntersectsRect(playerRect, teddyRect)){
            [teddy spawnOut];
            // [ItemsToDelete addObject:trashcan];
            NSLog(@"Hit! Teddy");
        }
        
        
        for (teddy in ItemsToDelete){
            // [Items_Fish removeObject:fish];
            //[self removeChild:trashcan cleanup:YES];
        }
    }
    //****************************************************************
}

-(void) Wave: (id)sender {
    if(startFlag_ == YES){
	[self spawning];
    }

}
#pragma mark - Spawning
-(void) spawning {
     
    for (int count=1; count<= 5; count++) {
        int randX = rand()%8;
        int randY = rand()%8;
        
        int locX = 40+randX*GRIDxSize;
        int locY = 40+randY*GRIDySize;
        if(Coord[randX][randY]==0){
            if(count==1){
                //Spawn Fish

                fish = [[Fish alloc] initWithPosition:ccp(locX,locY)];
                [fish spawnIn];
                [fish.sprite_ setOpacity:0];
                
                
                [self addChild:fish z:0];
                [Items_Fish addObject:fish];
                Coord[randX][randY]=1;
                fish.gridLocX = randX;
                fish.gridLocY = randY;
            }
            else if(count==2){
                //Spawn Trash Can
                trashcan = [[TrashCan alloc] initWithPosition:ccp(locX,locY)];
                [trashcan spawnIn];
                [trashcan.sprite_ setOpacity:0];
                [self addChild:trashcan z:10];
                
                [Items_Trash addObject:trashcan];
                Coord[randX][randY]=1;
                trashcan.gridLocX = randX;
                trashcan.gridLocY = randY;
            }
        else if(count==3){
                //Spawn Milk
                milk = [[Milk alloc] initWithPosition:ccp(locX,locY)];
                [milk spawnIn];
                [milk.sprite_ setOpacity:0];
                [self addChild:milk z:0];
                [Items_Milk addObject:milk];
                Coord[randX][randY]=1;
                milk.gridLocX = randX;
                milk.gridLocY = randY; 
            }
        else if(count==4){
                //Litter Box
                litterbox = [[Litterbox alloc] initWithPosition:ccp(locX,locY)];
                [litterbox spawnIn];
                [litterbox.sprite_ setOpacity:0];
                [self addChild:litterbox z:0];

                [Items_Litterbox addObject:litterbox];
                Coord[randX][randY]=1;
                litterbox.gridLocX = randX;
                litterbox.gridLocY = randY; 
        }
        else if(count==5){
                //Teddy
                teddy = [[Teddy alloc] initWithPosition:ccp(locX,locY)];
                [teddy spawnIn];
                [teddy.sprite_ setOpacity:0];
                [self addChild:teddy z:10];
                [Items_Teddy addObject:teddy];
                Coord[randX][randY]=1;
                teddy.gridLocX = randX;
                teddy.gridLocY = randY; 
        }

        }
    }
}


-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	return YES;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {    
   
    CGPoint touchLocation = [touch locationInView: [touch view]];		
    touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    Velocity = 480.0/3.0;
    CGPoint moveDifference = ccpSub(touchLocation, player.position);
    float distanceToMove = ccpLength(moveDifference);
    float moveDuration = distanceToMove / Velocity;
    
    NSLog(@"touchLocation: %f, player: %f",touchLocation.x,player.position.x);
    NSLog(@"Move Difference: %f",moveDifference.x);
    
    if (moveDifference.x < 0) {
        if(player.scaleX > 0){
        player.scaleX *= -1;
        }
    } else {
        if(player.scaleX <0){
        player.scaleX *= -1;
        }
    }    
    
    
    id moveAction = [CCSequence actions:[CCMoveTo actionWithDuration:moveDuration position:touchLocation],nil];
    [player runAction:moveAction];
    [player walk];
    
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    [title release];
    [instructions release];
    
    [startButton release];
    [helpButton release];
    [highScoreButton release];
    
    [player release];
    [Items_Fish release];
    Items_Fish = nil;
    [Items_Trash release];
    Items_Trash = nil;
    [trashcan release];
    [Items_Milk release];
    Items_Milk = nil;
    [Items_Litterbox release];
    Items_Litterbox = nil;
    [Items_Teddy release];
    Items_Teddy = nil;
    
    [ItemsToDelete release];
    ItemsToDelete = nil;
    [highscoreLabel_ release];
    [timerLabel_ release];
    [fish release];
	[spriteSheet release];
    

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
