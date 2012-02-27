//
//  GameCenterManager.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "GameCenterManagerDelegate.h"

@interface GameCenterManager : NSObject {
    
    id <GameCenterManagerDelegate> delegate_;
    
}

@property (nonatomic, assign) id <GameCenterManagerDelegate> delegate;

+ (GameCenterManager *) manager;

+ (void) purge;

- (void) reportScore:(int64_t)score category:(NSString *)category;

- (void) retrieveTopTenScores;

- (void) storeScoreForLater:(NSData *)scoreData;

- (void) submitSavedScores;

- (void) authenticateLocalUser;

@end
