//
//  RBPlayer.h
//  Robots
//
//  Created by Aijaz Ansari on 11/8/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "RBItem.h"

@interface RBPlayer : RBItem

@property (readonly, nonatomic) BOOL isDead;

-(void) updatePlayerStatus: (BOOL) dead;

@end
