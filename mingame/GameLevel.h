//
//  GameLevel.h
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.H>
#import "GameObject.h"

@interface GameLevel : NSObject

@property NSMutableArray * objects;
@property (strong) GameObject * player;
@property (strong) GameObject * end;

- (void) resetObjectPositions;

@end
