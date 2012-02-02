//
//  Debug.h
//  SC2
//
//  Created by Jantorn Jiambutr on 1/29/12.
//  Copyright (c) 2012 Deloitte. All rights reserved.
//

#define DEBUG_BOUNDINGBOX 0

#define DEBUG_DEALLOC 0

#define DebugPoint(s, p) NSLog(@"%@: (%4.2f, %4.2f)", s, p.x, p.y)
#define DebugRect(s, r) NSLog(@"%@: (%4.2f, %4.2f, %4.2f, %4.2f)", s, r.origin.x, r.origin.y, r.size.width, r.size.height)