//
//  ItemLocation.h
//  Robots
//
//  Created by Aijaz Ansari on 11/1/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemLocation : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;

-(instancetype) initWithColumn: (NSInteger) column row: (NSInteger) row;
@end
