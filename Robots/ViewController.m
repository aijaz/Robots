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



@interface ViewController () {}

// Model
@property (strong, nonatomic) RBArena * arena;

// View
@property (weak, nonatomic) IBOutlet ArenaView *arenaView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up the model
    self.arena = [[RBArena alloc] init];
    
    
    [self.arenaView setColumns:self.arena.width rows:self.arena.height];
    [self.arenaView setPlayerLocation:[[ItemLocation alloc] initWithColumn:self.arena.playerStartX row:self.arena.playerStartY]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
