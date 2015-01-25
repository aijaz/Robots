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
        // Create an arena
        RBArena * arena = [[RBArena alloc] init];
        NSLog(@"\n%@", arena);

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
            /*
             */
            
            char move[8];
            
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
                case 't':
                    [arena teleport];
                    break;
                case 's':
                    if (arena.safeTeleportsLeft > 0) {
                        [arena safeTeleport];
                    }
                    else {
                        NSLog(@"Sorry, out of safe teleports");
                    }
                    break;
                default:
                    break;
            }
            
            if (arena.player.isDead) {
                NSLog(@"\n%@", arena);
                NSLog(@"Game over");
                break;
            }
            if ([arena.robots count] == 0) {
                NSLog(@"\n%@", arena);
                NSLog(@"LEVEL UP!");
                [arena startLevel:arena.level + 1];
                printf("Hit enter to continue ");
                scanf("%s", move);
            }
            
        }
    }
    
    return 0;
}

