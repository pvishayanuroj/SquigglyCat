//
//  ItemDelegate.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

@class Item;

@protocol ItemDelegate <NSObject>

- (void) itemCollided:(Item *)item;

@end