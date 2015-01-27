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
@property (weak, nonatomic) IBOutlet UIButton *bombButton;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UIButton *waitButton;
@property (assign, nonatomic) BOOL inWait;
@property (strong, nonatomic) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *levelUpButton;

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
    [self.view addGestureRecognizer:tap];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPress];

    self.restartButton.hidden = YES;
    self.levelUpButton.hidden = YES;

    
    [self refreshScreen];

}

#pragma mark - Gesture Recognizers

-(void) pan: (UIPanGestureRecognizer *) pan {
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }
    
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
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }
    
    [self moveToSpot:5];
}


-(void) longPress: (UILongPressGestureRecognizer *) longPress {
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }

    
}


-(NSInteger) spotFromCGPoint: (CGPoint) point {
    CGFloat radians = atan2f(-point.y, point.x);
    CGFloat degrees = ((radians * 180) / M_PI);
    if (degrees < 0) { degrees = 360 + degrees; }

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


-(void) translateFromModelToView {
    
    
    if (self.arena.player.isDead) {
        self.arenaView.gameOver = YES;
        self.bombButton.hidden = YES;
        self.teleportButton.hidden = YES;
        self.waitButton.hidden = YES;
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
    
    
    if (self.arena.safeTeleportsLeft) {
        [self.teleportButton setTitle: [NSString stringWithFormat:@"Safe Teleport: %zd", self.arena.safeTeleportsLeft] forState:UIControlStateNormal];
    }
    else {
        [self.teleportButton setTitle: @"Teleport" forState:UIControlStateNormal];
    }
    
    if (self.arena.bombsLeft) {
        self.bombButton.enabled = YES;
    }
    else {
        self.bombButton.enabled = NO;
    }
    
    if ([self.arena.robots count] == 0 && !self.arena.player.isDead) {
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.levelUpButton.hidden = NO;
        self.bombButton.hidden = YES;
        self.teleportButton.hidden = YES;
        self.waitButton.hidden = YES;
    }
    
}

- (IBAction)teleport:(UIButton *)sender {
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }

    if (self.arena.safeTeleportsLeft) {
        [self.arena safeTeleport];
    }
    else {
        [self.arena teleport];
    }
    
    
    [self translateFromModelToView];
}


- (IBAction)bomb:(UIButton *)sender {
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }

}

- (IBAction)wait:(id)sender {
    if (self.timer) { return; }
    if (self.arena.player.isDead) { return; }
    
    [self moveToSpot:5];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    
    
}

- (IBAction)levelUp:(id)sender {
    self.bombButton.hidden = NO;
    self.teleportButton.hidden = NO;
    self.waitButton.hidden = NO;
    self.levelUpButton.hidden = YES;
    [self.arena startLevel:self.arena.level + 1];
    [self translateFromModelToView];
}

-(void) handleTimer: (id) sender {
    if ( ([self.arena.robots count] == 0) || self.arena.player.isDead) {
        [self.timer invalidate];
        self.timer = nil;
    }
    else {
        [self moveToSpot:5];
    }
}

- (IBAction)restart:(id)sender {
    if (self.timer) { return; }
    
    self.bombButton.hidden = NO;
    self.teleportButton.hidden = NO;
    self.waitButton.hidden = NO;
    self.restartButton.hidden = YES;
    
    [self.arena restartGame];
    self.arenaView.gameOver = NO;
    [self translateFromModelToView];
    
}

@end
