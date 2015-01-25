//
//  ItemLocation.m
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import "ItemLocation.h"

@implementation ItemLocation

-(instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        self.column = column;
        self.row = row;
    }
    return self;
}

@end
