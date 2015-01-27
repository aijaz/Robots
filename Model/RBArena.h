//
//  RBArena.h
//  Robots
//
//  Created by Aijaz Ansari on 11/8/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// forward declaration that says that there is a class called RBPlayer
@class RBPlayer;

@interface RBArena : NSObject

// These are the dimensions of the board
@property (readonly, nonatomic) NSInteger width;
@property (readonly, nonatomic) NSInteger height;

// This is the position of the player at the start of a level
@property (readonly, nonatomic) NSInteger playerStartX;
@property (readonly, nonatomic) NSInteger playerStartY;

// This is the current level
@property (readonly, nonatomic) NSInteger level;

// The number of safe teleports remaining
@property (readonly, nonatomic) NSInteger safeTeleportsLeft;

// The number of bombs available
@property (readonly, nonatomic) NSInteger bombsLeft;

// items on the board

// robots
@property (strong, nonatomic) NSMutableSet * robots;

// player
@property (strong, nonatomic) RBPlayer * player;

// debris
@property (strong, nonatomic) NSMutableSet * debris;


// METHODS

// The spot is a relative location based on the current location of the player
// 1 2 3
// 4 5 6
// 7 8 9
-(void) movePlayerToSpot: (NSInteger) spot;

// random teleport
-(void) teleport;

// safe teleport
-(void) safeTeleport;

// start at the level specified
-(void) startLevel: (NSInteger) level;

// restart the game after the player dies (always from level 1)
-(void) restartGame;

// a list of valid moves
-(NSDictionary *) validMoves;

// detonate a bomb - kill any robots that are adjacent to you
-(void) bomb;

// accept input from user - translate it to a move
-(void) acceptInput;


@end
