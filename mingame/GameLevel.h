//
//  GameLevel.h
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

@interface GameLevel : NSObject

@property (strong) GameObject * player;
@property (strong) GameObject * end;
@property int height;
@property int width; 

- (void) resetObjectPositions;
- (void) addObject:(GameObject *)obj;
- (NSMutableArray *) getObjects;

@end
