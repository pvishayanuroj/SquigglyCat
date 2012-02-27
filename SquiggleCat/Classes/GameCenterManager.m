//
//  GameCenterManager.m
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import "GameCenterManager.h"

@implementation GameCenterManager

@synthesize delegate = delegate_;

// For singleton
static GameCenterManager *manager_ = nil;

#pragma mark - Object Lifecycle

+ (GameCenterManager *) manager
{
    @synchronized (self) {
        if (manager_ == nil) {
            // Alloc eventually calls allocWithZone
            [[self alloc] init];
        }
    }
    return manager_;
}

// Override allocWithZone to avoid potential page thrashing
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (manager_ == nil) {
            manager_ = [super allocWithZone:zone];
            return manager_;
        }
    }
    return nil;
}

+ (void) purge
{
    [manager_ release];
    manager_ = nil;
}

- (id) init
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        
    }
     
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) reportScore:(int64_t)score category:(NSString *)category
{
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
    scoreReporter.value = score;
    
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        
        // If error reporting score, store for later
        if (error != nil) {
            NSLog(@"Error reporting score (save for later): %@", error.localizedDescription);
            NSData *savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
            [self storeScoreForLater:savedScoreData];
        }        
        
        //[self callDelegateOnMainMethod:@selector(scoreReported:) withArg:nil error:error];
    }];
}

- (void) retrieveTopTenScores
{
    GKLeaderboard *leaderboardRequest = [[[GKLeaderboard alloc] init] autorelease];
    
    if (leaderboardRequest != nil) {
        leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
        leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardRequest.range = NSMakeRange(1, 10);
        
        [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
            // Error occurred retrieving leaderboard
            if (error != nil) {
                NSLog(@"Error retrieving leaderboard: %@", error.localizedDescription);
            }
            // Scores retrieved
            else if (scores != nil) {
                if (delegate_ && [delegate_ respondsToSelector:@selector(leaderboardRetrieved:)]) {
                    [delegate_ leaderboardRetrieved:scores];
                }
            }
        }];
    }
}

- (void) storeScoreForLater:(NSData *)scoreData
{
    NSArray *savedScores = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Saved Scores"];
    
    NSMutableArray *scores;
    
    if (savedScores == nil) {
        scores = [NSMutableArray array];
    }
    else {
        scores = [NSMutableArray arrayWithArray:savedScores];
    }
    
    [scores addObject:scoreData];
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"Saved Scores"];
}

- (void) submitSavedScores 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *scores = [defaults arrayForKey:@"Saved Scores"];
    
    [defaults removeObjectForKey:@"Saved Scores"];
    
    // If any submitted scores to report
    if (scores != nil) {
        for (NSData *scoreData in scores) {
            GKScore *scoreReporter = [NSKeyedUnarchiver unarchiveObjectWithData:scoreData];
            
            [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
                
                // If error reporting score, store for later                
                if (error != nil) {
                    NSData *savedScoreData = [NSKeyedArchiver archivedDataWithRootObject:scoreReporter];
                    [self storeScoreForLater:savedScoreData];
                }
            }];
        }
    }
}

- (void) authenticateLocalUser
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated) {
        NSLog(@"Local player is already authenticated");
        return;
    }
    
    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
        // Submit any saved scores
        if (error == nil) {
            NSLog(@"Logged into Game Center");
            [self submitSavedScores];
        }
        else {
            NSLog(@"Gamekit authentication error: %@", error.localizedDescription);
        }
    }];    
}

@end
