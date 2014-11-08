//
//  RBItem.h
//  Robots
//
//  Created by Aijaz Ansari on 11/8/14.
//  Copyright (c) 2014 Euclid Software, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBItem : NSObject

@property (readonly, nonatomic) NSInteger x;
@property (readonly, nonatomic) NSInteger y;

-(void) moveToNewX: (NSInteger) x newY: (NSInteger) y;

@end
