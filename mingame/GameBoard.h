//
//  GameBoard.h
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@class GameConfig;

static const int GAME_BOARD_COL_COUNT = 25;
static const int GAME_BOARD_ROW_COUNT = 70;

@interface GameBoard : NSObject

@property (strong) NSMutableArray * board;
@property (strong) NSMutableArray * objects;
@property (weak) GameConfig * config;

- (void) addObjectToBoard:(GameObject *) obj;
- (void) placeObjectInBoard:(GameObject *)obj;
- (void) removeObjectFromBoard:(GameObject *)obj;
- (NSMutableArray *) getColForIndex:(int)index;
- (void) moveObjectByOffset:(GameObject *)obj xOffset:(int)x yOffset:(int)y;
- (void) moveObject:(GameObject *)obj x:(int)x y:(int)y;
- (void) clearBoard;

@end
