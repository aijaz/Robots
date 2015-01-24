//
//  main.m
//  RobotCLI
//
//  Created by Aijaz Ansari on 1/23/15.
//  Copyright (c) 2015 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBArena.h"
#import "RBPlayer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        RBArena * arena = [[RBArena alloc] init];

        
        while (arena.player.isDead == NO) {
            NSLog(@"\n%@", arena);
            NSDictionary * validMoves = [arena validMoves];
            
            // print valid moves
            NSLog(@"Valid Moves\n"
                  "%@ %@ %@\n"
                  "%@ %@ %@\n"
                  "%@ %@ %@\n"
                  , (validMoves[@1])? @"1" : @"-"
                  , (validMoves[@2])? @"2" : @"-"
                  , (validMoves[@3])? @"3" : @"-"
                  , (validMoves[@4])? @"4" : @"-"
                  , (validMoves[@5])? @"5" : @"-"
                  , (validMoves[@6])? @"6" : @"-"
                  , (validMoves[@7])? @"7" : @"-"
                  , (validMoves[@8])? @"8" : @"-"
                  , (validMoves[@9])? @"9" : @"-"
                  );
            
            char move[256];
            
            printf("Enter move: ");
            scanf("%s", move);
            
            if (move[0] == 'q') {
                break;
            }
            
            switch (move[0]) {
                case '1':
                    [arena movePlayerToSpot:1];
                    break;
                case '2':
                    [arena movePlayerToSpot:2];
                    break;
                case '3':
                    [arena movePlayerToSpot:3];
                    break;
                case '4':
                    [arena movePlayerToSpot:4];
                    break;
                case '5':
                    [arena movePlayerToSpot:5];
                    break;
                case '6':
                    [arena movePlayerToSpot:6];
                    break;
                case '7':
                    [arena movePlayerToSpot:7];
                    break;
                case '8':
                    [arena movePlayerToSpot:8];
                    break;
                case '9':
                    [arena movePlayerToSpot:9];
                    break;
                    
                default:
                    break;
            }
            
            if (arena.player.isDead) {
                NSLog(@"\n%@", arena);
                NSLog(@"Game over");
                break;
            }
            
        }
    }
    return 0;
}

