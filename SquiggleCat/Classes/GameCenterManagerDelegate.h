//
//  GameCenterManagerDelegate.h
//  SquiggleCat
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

@protocol GameCenterManagerDelegate <NSObject>

@optional

- (void) leaderboardRetrieved:(NSArray *)scores;

@end