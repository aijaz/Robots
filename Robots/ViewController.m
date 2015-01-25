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
    [self.arenaView setPlayerLocation:[[ItemLocation alloc] initWithColumn:self.arena.playerStartX row:self.arena.playerStartY]];

    [self translateRobotLocationsFromModelToView];
    [self translateDebrisLocationsFromModelToView];
    
    self.arenaView.gameOver = NO;
    
    [self refreshScreen];

}

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
