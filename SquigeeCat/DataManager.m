//
//  DataManager.m
//  SquigeeCat
//
//  Created by Dan Boriboon on 28/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "cocos2d.h"

@implementation DataManager
@synthesize highscore, gameFlag;

- (void) dealloc {
	[super dealloc];
}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// Singleton ///////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

static DataManager *sharedDataManager = nil;

+ (DataManager *) sharedManager
{
    @synchronized(self)
	{
        if (sharedDataManager == nil)
		{
            [[self alloc] init];
        }
    }
	
    return sharedDataManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
	{
        if(sharedDataManager == nil)
		{
            sharedDataManager = [super allocWithZone:zone];
            return sharedDataManager;
        }
    }
	
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{	
    return self;
}

- (id) retain
{
    return self;
}

- (unsigned) retainCount
{
    return UINT_MAX;
}
/*
- (void)release
{

}
*/

- (id) autorelease
{
    return self;
}


@end
