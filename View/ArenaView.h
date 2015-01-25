//
//  ArenaView.h
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemLocation.h"

@interface ArenaView : UIView

@property (strong, nonatomic) NSSet * robotLocations;
@property (strong, nonatomic) NSSet * debrisLocations;
@property (strong, nonatomic) ItemLocation * playerLocation;
@property (assign, nonatomic) BOOL gameOver;

-(void) setColumns:(NSInteger)columns rows:(NSInteger)rows;

@end
