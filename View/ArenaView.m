//
//  ArenaView.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "ArenaView.h"


@interface ArenaView ()

@property (assign, nonatomic) NSInteger numberOfColumns;
@property (assign, nonatomic) NSInteger numberOfRows;

@property (assign, nonatomic) CGFloat cellWidth;
@property (assign, nonatomic) CGFloat cellHeight;

@property (assign, nonatomic) CGFloat gridLineWidth;
@property (assign, nonatomic) CGFloat gridLineHeight;

@end

#define HORIZONTAL_PADDING 2

@implementation ArenaView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGSize size = self.bounds.size;
    
    self.cellWidth = (size.width - (HORIZONTAL_PADDING * 2)) / self.numberOfColumns;
    self.cellHeight = (size.height - (HORIZONTAL_PADDING * 2)) / self.numberOfRows;
    
    self.gridLineWidth = self.cellWidth * self.numberOfColumns;
    self.gridLineHeight = self.cellHeight * self.numberOfRows;
    
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1].CGColor); //change color here
    CGContextSetLineWidth(context, 1);
    
    NSInteger i = 0;
    for (CGFloat x = HORIZONTAL_PADDING; i <= self.numberOfColumns; x += self.cellWidth) {
        CGContextMoveToPoint(context, x, HORIZONTAL_PADDING);
        CGContextAddLineToPoint(context, x, self.gridLineHeight + 2);
        i++;
    }
    
    i = 0;
    for (CGFloat y = HORIZONTAL_PADDING; i <= self.numberOfRows; y += self.cellHeight) {
        CGContextMoveToPoint(context, HORIZONTAL_PADDING, y);
        CGContextAddLineToPoint(context, self.gridLineWidth + 2, y);
        i++;
    }

    
    CGContextStrokePath(context);
    
    [self drawPlayer];
    
    [self drawRobots];
    [self drawDebris];
}

-(void) setColumns:(NSInteger)columns rows:(NSInteger)rows {
    _numberOfColumns = columns;
    _numberOfRows = rows;
}


-(void) drawPlayer {
    CGRect playerRect = [self rectForColumn:self.playerLocation.column row:self.playerLocation.row];
    UIImage * playerImage;
    if (self.gameOver) {
        playerImage = [UIImage imageNamed:@"dead"];
    }
    else {
        playerImage = [UIImage imageNamed:@"player"];
    }
    [playerImage drawInRect:playerRect];
}

-(void) drawRobots {
    UIImage * robotImage = [UIImage imageNamed:@"robot"];
    for (ItemLocation * location in self.robotLocations) {
        CGRect robotRect = [self rectForColumn:location.column row:location.row];
        [robotImage drawInRect:robotRect];
    }
}

-(void) drawDebris {
    UIImage * debrisImage = [UIImage imageNamed:@"debris"];
    for (ItemLocation * location in self.debrisLocations) {
        CGRect debrisRect = [self rectForColumn:location.column row:location.row];
        [debrisImage drawInRect:debrisRect];
    }
}


-(CGRect) rectForColumn: (NSInteger) column row: (NSInteger) row {
    CGFloat x = column * self.cellWidth + HORIZONTAL_PADDING;
    CGFloat y = row * self.cellHeight + HORIZONTAL_PADDING;
    
    return CGRectMake(x, y, self.cellWidth, self.cellHeight);
}

@end
