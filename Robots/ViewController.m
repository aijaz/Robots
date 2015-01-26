//
//  ViewController.m
//  Robots
//
//  Created by Aijaz Ansari on 11/8/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "ViewController.h"
#import "RBArena.h"
#import "RBPlayer.h"
#import "ArenaView.h"
#import "ItemLocation.h"
#import "RBDebris.h"
#import "RBRobot.h"



@interface ViewController () {}

// Model
@property (strong, nonatomic) RBArena * arena;

// View
@property (weak, nonatomic) IBOutlet ArenaView *arenaView;
@property (weak, nonatomic) IBOutlet UIButton *bnw;
@property (weak, nonatomic) IBOutlet UIButton *bn;
@property (weak, nonatomic) IBOutlet UIButton *bne;
@property (weak, nonatomic) IBOutlet UIButton *bw;
@property (weak, nonatomic) IBOutlet UIButton *bc;
@property (weak, nonatomic) IBOutlet UIButton *be;
@property (weak, nonatomic) IBOutlet UIButton *bsw;
@property (weak, nonatomic) IBOutlet UIButton *bs;
@property (weak, nonatomic) IBOutlet UIButton *bse;
@property (weak, nonatomic) IBOutlet UIButton *teleportButton;
@property (weak, nonatomic) IBOutlet UIButton *safeTeleportButton;
@property (weak, nonatomic) IBOutlet UIButton *bombButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up the model
    self.arena = [[RBArena alloc] init];
    
    
    [self.arenaView setColumns:self.arena.width rows:self.arena.height];
    [self.arenaView setPlayerLocation:[[    ItemLocation alloc] initWithColumn:self.arena.playerStartX row:self.arena.playerStartY]];

    [self translateRobotLocationsFromModelToView];
    [self translateDebrisLocationsFromModelToView];
    
    self.arenaView.gameOver = NO;
    
    // add gesture recognizers
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.arenaView addGestureRecognizer:tap];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.arenaView addGestureRecognizer:longPress];
    
    
    [self refreshScreen];

}

#pragma mark - Gesture Recognizers

-(void) pan: (UIPanGestureRecognizer *) pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:{
//            CGPoint translation = [pan translationInView:self.view];
//            NSInteger spot = [self spotFromCGPoint:translation];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGPoint translation = [pan translationInView:self.view];
            NSInteger spot = [self spotFromCGPoint:translation];
            [self handleMoveRequestToSpot: spot];
        }
        default:
            break;
    }
}


-(void) tap: (UITapGestureRecognizer *) tap {
    [self moveToSpot:5];
}


-(void) longPress: (UILongPressGestureRecognizer *) longPress {
}


-(NSInteger) spotFromCGPoint: (CGPoint) point {
    CGFloat radians = atan2f(-point.y, point.x);
    CGFloat degrees = ((radians * 180) / M_PI);
    if (degrees < 0) { degrees = 360 + degrees; }
    NSLog(@"degrees is %.1f", degrees);

    if (degrees < 0 + 22.5) {
        return 6;
    }
    else if (degrees <= 45 + 22.5) {
        return 3;
    }
    else if (degrees <= 90 + 22.5) {
        return 2;
    }
    else if (degrees <= 135 + 22.5) {
        return 1;
    }
    else if (degrees <= 180 + 22.5) {
        return 4;
    }
    else if (degrees <= 225 + 22.5) {
        return 7;
    }
    else if (degrees <= 270 + 22.5) {
        return 8;
    }
    else if (degrees < 315 + 22.5) {
        return 9;
    }
    else {
        return 6;
    }
}

-(void) handleMoveRequestToSpot: (NSInteger) spot {
    NSDictionary * validMoves = [self.arena validMoves];
    if (validMoves[@(spot)]) {
        // it's a valid move
        [self moveToSpot:spot];
    }
    else {
        [self shakeArenaView];
    }
}

-(void) moveToSpot: (NSInteger) spot {
    [self.arena movePlayerToSpot:spot];
    if (self.arena.player.isDead) {
        self.arenaView.gameOver = YES;
    }
    [self translateFromModelToView];

}

-(void) shakeArenaView {
    [UIView animateWithDuration:0.1 animations:^{
        CGRect f = self.arenaView.frame;
        f.origin.x -= 10;
        self.arenaView.frame = f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect f = self.arenaView.frame;
            f.origin.x += 20;
            self.arenaView.frame = f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect f = self.arenaView.frame;
                f.origin.x -= 20;
                self.arenaView.frame = f;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    CGRect f = self.arenaView.frame;
                    f.origin.x += 20;
                    self.arenaView.frame = f;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.1 animations:^{
                        CGRect f = self.arenaView.frame;
                        f.origin.x -= 10;
                        self.arenaView.frame = f;
                    }];
                }];
            }];
        }];
    }];
}

#pragma mark - Translations from model to view

-(void) translateRobotLocationsFromModelToView {
    NSMutableSet * robotLocations = [NSMutableSet setWithCapacity:[self.arena.robots count]];
    for (RBRobot * robot in self.arena.robots) {
        [robotLocations addObject:[[ItemLocation alloc] initWithColumn:robot.x row:robot.y]];
    }
    self.arenaView.robotLocations = robotLocations;
}
-(void) translateDebrisLocationsFromModelToView {
    NSMutableSet * debrisLocations = [NSMutableSet setWithCapacity:[self.arena.debris count]];
    for (RBDebris * debris in self.arena.debris) {
        [debrisLocations addObject:[[ItemLocation alloc] initWithColumn:debris.x row:debris.y]];
    }
    self.arenaView.debrisLocations = debrisLocations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleMove:(UIButton *)sender {
    NSInteger spot = 0;
    if (sender == self.bnw) { spot = 1; }
    else if (sender == self.bn) { spot = 2; }
    else if (sender == self.bne) { spot = 3; }
    else if (sender == self.bw) { spot = 4; }
    else if (sender == self.bc) { spot = 5; }
    else if (sender == self.be) { spot = 6; }
    else if (sender == self.bsw) { spot = 7; }
    else if (sender == self.bs) { spot = 8; }
    else if (sender == self.bse) { spot = 9; }
    
    [self.arena movePlayerToSpot:spot];
    if (self.arena.player.isDead) {
        self.arenaView.gameOver = YES;
    }
    
    [self translateFromModelToView];
}

-(void) translateFromModelToView {
    
    self.restartButton.hidden = YES;
    
    if (self.arena.player.isDead) {
        self.arenaView.gameOver = YES;
        self.restartButton.hidden = NO;
    }
    
    self.levelLabel.text = [NSString stringWithFormat:@"Level %zd", self.arena.level];
    
    // translate player location
    self.arenaView.playerLocation.row = self.arena.player.y;
    self.arenaView.playerLocation.column = self.arena.player.x;
    
    // translate robot locations
    [self translateRobotLocationsFromModelToView];
    [self translateDebrisLocationsFromModelToView];
    
    [self refreshScreen];
}

-(void) refreshScreen {
    [self.arenaView setNeedsDisplay];
    
    NSDictionary * validMoves = [self.arena validMoves];
    
    if (validMoves[@1]) { self.bnw.enabled = YES; } else { self.bnw.enabled = NO; }
    if (validMoves[@2]) { self.bn.enabled = YES; } else { self.bn.enabled = NO; }
    if (validMoves[@3]) { self.bne.enabled = YES; } else { self.bne.enabled = NO; }
    if (validMoves[@4]) { self.bw.enabled = YES; } else { self.bw.enabled = NO; }
    if (validMoves[@5]) { self.bc.enabled = YES; } else { self.bc.enabled = NO; }
    if (validMoves[@6]) { self.be.enabled = YES; } else { self.be.enabled = NO; }
    if (validMoves[@7]) { self.bsw.enabled = YES; } else { self.bsw.enabled = NO; }
    if (validMoves[@8]) { self.bs.enabled = YES; } else { self.bs.enabled = NO; }
    if (validMoves[@9]) { self.bse.enabled = YES; } else { self.bse.enabled = NO; }
    
    if (self.arena.safeTeleportsLeft) {
        self.safeTeleportButton.enabled = YES;
        [self.safeTeleportButton setTitle:[NSString stringWithFormat:@"st: %zd", self.arena.safeTeleportsLeft] forState:UIControlStateNormal];
    }
    else {
        self.safeTeleportButton.enabled = NO;
        [self.safeTeleportButton setTitle:@"st" forState:UIControlStateNormal];
    }
    
    if (self.arena.bombsLeft) {
        self.bombButton.enabled = YES;
    }
    else {
        self.bombButton.enabled = NO;
    }
    
    if ([self.arena.robots count] == 0) {
        [self.arena startLevel:self.arena.level + 1];
        [self translateFromModelToView];
    }
    
}

- (IBAction)teleport:(UIButton *)sender {
    [self.arena teleport];
    
    [self translateFromModelToView];
}

- (IBAction)safeTeleport:(UIButton *)sender {
    [self.arena safeTeleport];
    
    [self translateFromModelToView];
}

- (IBAction)bomb:(UIButton *)sender {
}

- (IBAction)restart:(id)sender {
    [self.arena restartGame];
    self.arenaView.gameOver = NO;
    [self translateFromModelToView];
}

@end
