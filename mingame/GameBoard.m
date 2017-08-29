//
//  GameBoard.m
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameBoard.h"
#import "GameConfig.h"

@implementation GameBoard

- (instancetype)init {
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray array];
        self.board = [NSMutableArray arrayWithCapacity:GAME_BOARD_COL_COUNT];
        for (int i = 0; i < GAME_BOARD_ROW_COUNT; i++) {
            NSMutableArray * col = [NSMutableArray arrayWithCapacity:GAME_BOARD_ROW_COUNT];
            [self.board addObject:col];
            for (int j = 0; j < GAME_BOARD_ROW_COUNT; j++) {
                [col addObject:[NSNull null]];
            }
        }
    }
    return self;
}

- (void) clearBoard {
    self.objects = [NSMutableArray array];
    self.board = [NSMutableArray arrayWithCapacity:GAME_BOARD_COL_COUNT];
    for (int i = 0; i < GAME_BOARD_ROW_COUNT; i++) {
        NSMutableArray * col = [NSMutableArray arrayWithCapacity:GAME_BOARD_ROW_COUNT];
        [self.board addObject:col];
        for (int j = 0; j < GAME_BOARD_ROW_COUNT; j++) {
            [col addObject:[NSNull null]];
        }
    }
}

- (void) addObjectToBoard:(GameObject *) obj {
    [self.objects addObject:obj];
    [self placeObjectInBoard:obj];
}

- (void) placeObjectInBoard:(GameObject *)obj {
    NSMutableArray * col = [self getColForIndex:obj.position.x];
    [col replaceObjectAtIndex:obj.position.y withObject:obj];
}

- (void) removeObjectFromBoard:(GameObject *)obj {
    NSMutableArray * col = [self getColForIndex:obj.position.x];
    [col replaceObjectAtIndex:obj.position.y withObject:[NSNull null]];
    [self.objects removeObject:obj];
}

- (NSObject *) getObjectAtX:(int)x y:(int)y {
    NSMutableArray * col = [self getColForIndex:x];
    return [col objectAtIndex:y];
}

- (void) moveObjectByOffset:(GameObject *)obj xOffset:(int)x yOffset:(int)y {
    CGPoint oldPoint = obj.position;
    int newX = (oldPoint.x == 0 && x < 0) ? 0 : MIN(oldPoint.x + x, GAME_BOARD_COL_COUNT);
    int newY = (oldPoint.y == 0 && y < 0) ? 0 : MIN(oldPoint.y + y, GAME_BOARD_ROW_COUNT);
    
    NSObject * existingObj = [self getObjectAtX:newX y:newY];
    if (existingObj != [NSNull null]) {
        bool isDoor = existingObj == self.config.door;
        if (isDoor && self.config.playerKeyCount == 0) {
            return;
        } else if (!isDoor) {
            bool isEnd = existingObj == self.config.end;
            bool isKey = existingObj == self.config.key;
            if (!isEnd && !isKey) {
                return;
            }
        }
    }
    
    NSLog(@"%d %d", newX, newY);
    [self moveObject:obj x:newX y:newY];
}

- (void) moveObject:(GameObject *)obj x:(int)x y:(int)y {
    [self removeObjectFromBoard:obj];
    obj.position = CGPointMake(x, y);
    [self addObjectToBoard:obj];
}

- (NSMutableArray *) getColForIndex:(int)index { return [self.board objectAtIndex:index]; }

@end
