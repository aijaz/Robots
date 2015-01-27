//
//  RBArena.m
//  Robots
//
//  Created by Aijaz Ansari on 11/8/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "RBArena.h"
#import "RBPlayer.h"
#import "RBRobot.h"
#import "RBDebris.h"


@interface RBArena ()

// the current level of the game
@property (assign, nonatomic) NSInteger level;

// a two-dimensional array that specifies the board
@property (strong, nonatomic) NSMutableArray * board;

@end


@implementation RBArena


- (instancetype) init {
    self = [super init];
    if (self) {
        // custom initialization
        _width = 15;
        _height = 15;
        
        // _ _ _ _ _ _ _ _ _
        // 0 1 2 3 4 5 6 7 8
        //
        
        // place the player in the center of the board
        // force the coordinates to be whole numbers
        // (we haven't spoken about integer division yet)
        _playerStartX = (NSInteger)(_width/2);
        _playerStartY = (NSInteger)(_height/2);
        
        _level = 1;
        
        // a board has _height number of rows
//        _board = [NSMutableArray arrayWithCapacity:_height];
        _board = [[NSMutableArray alloc] init];

        
        // for each row create _width number of columns
        NSInteger h;
        for (h = 0; h < _height; h = h + 1) {
            NSMutableArray * row = [NSMutableArray arrayWithCapacity:_width];
            NSInteger w = 0;
            for (w = 0; w < _width; w++) {
                [row addObject:[NSNull null]]; // add a null object into each column in this row
            }
            [_board addObject:row];
        }
        
        /*
         _board -> 
         [
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         [◻️◻️◻️◻️◻️◻️◻️◻️◻️]
         ]
         
         
         NOT
         
         _board -> 
         [
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]  [◻️]
         ]
         */
        
        // Complete initialization
        _player = [[RBPlayer alloc] init];
        [_player updatePlayerStatus:NO];
        
        // do whatever is necessary for this level
        [self startLevel:_level];
        
    }
    return self;
}


// The spot is a relative location based on the current location of the player
// 1 2 3
// 4 5 6
// 7 8 9
-(void) movePlayerToSpot: (NSInteger) spot {
    
    // don't do anything if the player is already dead
    if (self.player.isDead) {
        return;
    }
    
    // calculate the x and y offsets based on the spot
    NSInteger xOffset = [self xOffsetForSpot:spot];
    NSInteger yOffset = [self yOffsetForSpot:spot];
    
    // apply the offsets to determine the new player location
    NSInteger newPlayerX = self.player.x + xOffset;
    NSInteger newPlayerY = self.player.y + yOffset;
    
    // pick up player before setting it back down
    self.board[self.player.y][self.player.x] = [NSNull null];
    
    // set the player back down
    [self moveItem:self.player toX:newPlayerX andY:newPlayerY];
    
    // move all the robots one step towards the player
    [self moveRobotsTowardsPlayer];
}

-(void) moveRobotsTowardsPlayer {
    // The set of robots may beed to be changed if the robots
    // collide with anything after they move towards the player
    // It's easiest to make a new set and work on that
    
    NSMutableSet * newRobotSet = [NSMutableSet setWithCapacity:[self.robots count]];
    
    // Pick up all the robots of the board
    for (RBRobot * robot in self.robots) {
        self.board[robot.y][robot.x] = [NSNull null];
    }
    
    // now move all robots and check for collisions
    for (RBRobot * robot in self.robots) {
        // get the robot's location
        NSInteger robotX = robot.x;
        NSInteger robotY = robot.y;
        
        // update the x location of the robot, if necessary
        if (robotX < self.player.x) {
            // robot to the left
            robotX = robotX + 1; // or robotX += 1 // or robotX++
        }
        else if (robotX > self.player.x) {
            robotX--;
        }
        
        // update the y location of the robot, if necessary
        if (robotY < self.player.y) {
            robotY += 1;
        }
        else if (robotY > self.player.y) {
            robotY--;
        }
        
        // now that we know the new x and y coordinates of the robot, we need to see if the robot collided with anything or not
        
        if (self.board[robotY][robotX] == [NSNull null]) {
            // the spot is empty
            [self moveItem:robot toX:robotX andY:robotY];
            [newRobotSet addObject:robot];
        }
        else {
            // there is already something in the spot  // new
            if ([self.board[robotY][robotX] class] == [RBPlayer class]) {
                // there is the player there
                [self.player updatePlayerStatus:YES];
                // don't need to add the robot to the newRobotSet because the game is over
                // We'll show the dead player there instead
            }
            else if ([self.board[robotY][robotX] class] == [RBRobot class]) {
                // there's a robot there
                RBRobot * previousRobot = self.board[robotY][robotX];
                [newRobotSet removeObject:previousRobot];
                RBDebris * newDebris = [[RBDebris alloc] init];
                [self moveItem:newDebris toX:robotX andY:robotY];
                [self.debris addObject:newDebris];
            }
            else if ([self.board[robotY][robotX] class] == [RBDebris class]) {
                // there is debris there
                // don't add this robot to the newRobotSet
            }
        }
    }
    
    // replace the set of robots
    self.robots = newRobotSet;
    
}


-(NSInteger) xOffsetForSpot: (NSInteger) spot {
    NSInteger answer = 0;
    if (spot == 1 || spot == 4 || spot == 7) {
        answer = -1;
    }
    else if (spot == 3 || spot == 6 || spot == 9) {
        answer = 1;
    }
    return answer;
}

-(NSInteger) yOffsetForSpot: (NSInteger) spot {
    NSInteger answer = 0;
    if (spot <= 3) {
        answer = -1;
    }
    else if (spot >= 7) {
        answer = 1;
    }
    return answer;
}




// start at the level specified
-(void) startLevel: (NSInteger) level {
    self.level = level;
    
    // clear the board first
    for (NSInteger h = 0; h < self.height; h++) {
        for (NSInteger w = 0; w < self.width; w++ ) {
            self.board[h][w] = [NSNull null];
        }
    }
    
    // move the player to the center of the board
    [self moveItem:self.player toX:self.playerStartX andY:self.playerStartY]; // new

    
    // start with 10 robots, and increase by 3 every level
    NSInteger numRobots = 10 + ((self.level - 1) * 3);
    
    self.robots = [NSMutableSet setWithCapacity:numRobots];
    // it takes 2 robots to collide and make 1 debris
    self.debris = [NSMutableSet setWithCapacity:numRobots/2];
    
    while (numRobots > 0) {
        // add a robot to the board
        
        // generate two random numbers
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);
        
        BOOL isRandomSpotVacant;
        if (self.board[randomY][randomX] == [NSNull null]) {
            isRandomSpotVacant = YES;
        }
        else {
            isRandomSpotVacant = NO;
        }
        
        if (isRandomSpotVacant) {
            // move to robot to the random spot
            RBRobot * robot = [[RBRobot alloc] init];
            [self moveItem:robot toX:randomX andY:randomY];
            [self.robots addObject:robot];
            numRobots = numRobots - 1;
        }
        else {
        }
        // alternatively, you could skip isRandomSpotVacant altogether and do:
        // if (self.board[randomY][randomX] == [NSNull null]) { ... }
        
    }
    
    _safeTeleportsLeft = (level/2) + 1;
    _bombsLeft = level/4;
}

-(void) moveItem: (RBItem *) item toX: (NSInteger) x andY: (NSInteger) y {
    [item moveToNewX:x newY:y];
    self.board[y][x] = item;
}

#pragma mark - new code

// a list of valid moves
-(NSDictionary *) validMoves {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionaryWithCapacity:9];
    
    if ([self isSpotEmptyWithXOffset:-1 yOffset:-1]) { dictionary[@(1)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 0 yOffset:-1]) { dictionary[@(2)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 1 yOffset:-1]) { dictionary[@(3)] = @YES; }
    if ([self isSpotEmptyWithXOffset:-1 yOffset: 0]) { dictionary[@(4)] = @YES; }
    
    dictionary[@(5)] = @YES; // always ok to stay where you are
    
    if ([self isSpotEmptyWithXOffset: 1 yOffset: 0]) { dictionary[@(6)] = @YES; }
    if ([self isSpotEmptyWithXOffset:-1 yOffset: 1]) { dictionary[@(7)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 0 yOffset: 1]) { dictionary[@(8)] = @YES; }
    if ([self isSpotEmptyWithXOffset: 1 yOffset: 1]) { dictionary[@(9)] = @YES; }
    
    return dictionary;
}

-(BOOL) isSpotEmptyWithXOffset: (NSInteger) xOffset yOffset: (NSInteger) yOffset {
    // reject invalid moves first
    if (self.player.x + xOffset < 0
        || self.player.x + xOffset >= self.width
        || self.player.y + yOffset < 0
        || self.player.y + yOffset >= self.height) {
        return NO;
    }
    if (self.board[self.player.y + yOffset][self.player.x + xOffset] == [NSNull null]) {
        return YES;
    }
    else {
        return NO;
    }
}

-(NSString *) dumpBoard {
    NSMutableArray * rows = [NSMutableArray arrayWithCapacity:self.height];
    
    for (int i = 0; i < self.height; i++) {
        NSMutableArray * row = [NSMutableArray arrayWithCapacity:self.width];
        for (int j = 0; j < self.width; j++) {
            if (self.board[i][j] == [NSNull null]) {
                [row addObject:@"."];
            }
            else {
                id item = self.board[i][j];
                [row addObject:[item description]];
            }
        }
        [rows addObject:[row componentsJoinedByString:@""]];
    }
    [rows addObject:@"\n"];
    [rows addObject:[NSString stringWithFormat:@"Safe Teleports Left: %zd", self.safeTeleportsLeft]];
    return [rows componentsJoinedByString:@"\n"];
}

-(NSString *)description {
    return [self dumpBoard];
}


// random teleport
-(void)teleport {
    while (true) {
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);
        
        if (self.board[randomY][randomX] == [NSNull null]) {
            // "pick up player"
            self.board[self.player.y][self.player.x] = [NSNull null];
            [self moveItem:self.player toX:randomX andY:randomY];
            [self movePlayerToSpot:5]; // record a move to the new location
            return; // get out this infinite loop
        }
    }
}

// safe teleport
-(void) safeTeleport {
    _safeTeleportsLeft--;
    if (_safeTeleportsLeft < 0) {
        _safeTeleportsLeft = 0;
    }
    
    NSInteger n = 0;
    
    // first try a buffer zone of 2
    while (n < 100) {
        n++;
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);
        
        if (self.board[randomY][randomX] == [NSNull null]) {
            
            BOOL ok = YES;
            for (NSInteger y = randomY - 2; y <= randomY + 2; y++) {
                for (NSInteger x = randomX - 2; x <= randomX + 2; x++) {
                    if (y >= 0 && y < self.height && x >= 0 && x < self.width) {
                        if (self.board[y][x] != [NSNull null]) {
                            ok = NO;
                            continue;
                        }
                        else {
                            // This spot is okay,
                            // But there is no guarantee that the other spots
                            // in that 2 spot buffer are okay as well
                            //
                        }
                    }
                }
            }
            
            if (ok) {
                // "pick up player"
                self.board[self.player.y][self.player.x] = [NSNull null];
                [self moveItem:self.player toX:randomX andY:randomY];
                [self movePlayerToSpot:5]; // record a move to the new location
                return; // get out this infinite loop
            }
        }
    }
    
    n = 0;
    // now try a buffer zone of 1
    while (n < 100) {
        n++;
        NSInteger randomX = arc4random_uniform((UInt32) self.width);
        NSInteger randomY = arc4random_uniform((UInt32) self.height);
        
        if (self.board[randomY][randomX] == [NSNull null]) {
            
            BOOL ok = YES;
            for (NSInteger y = randomY - 1; y <= randomY + 1; y++) {
                for (NSInteger x = randomX - 1; x <= randomX + 1; x++) {
                    if (y >= 0 && y < self.height && x >= 0 && x < self.width) {
                        if (self.board[y][x] != [NSNull null]) {
                            ok = NO;
                            continue;
                        }
                        else {
                            // This spot is okay,
                            // But there is no guarantee that the other spots
                            // in that 1 spot buffer are okay as well
                            //
                        }
                    }
                }
            }
            
            if (ok) {
                // "pick up player"
                self.board[self.player.y][self.player.x] = [NSNull null];
                [self moveItem:self.player toX:randomX andY:randomY];
                [self movePlayerToSpot:5]; // record a move to the new location
                return; // get out this infinite loop
            }
        }
    }
    
    [self teleport];
}



// detonate a bomb - kill any robots that are adjacent to you
-(void) bomb {
    
}

// accept input from user - translate it to a move
-(void)acceptInput {
}

// restart the game after the player dies (always from level 1)
-(void) restartGame {
    
}


@end
