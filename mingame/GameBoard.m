//
//  GameBoard.m
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameBoard.h"

@implementation GameBoard

- (instancetype)initWithColumnCount:(int)columnCount rowCount:(int)rowCount {
    self = [super init];
    if (self) {
        self.columnCount = columnCount;
        self.rowCount = rowCount;
        [self clearBoard];
    }
    return self;
}

+ (GameBoard*) createBoardForLevel:(GameLevel *)level {
    GameBoard * b = [[GameBoard alloc] initWithColumnCount:level.width rowCount:level.height];
    for (GameObject * obj in [level getObjects]) {
        [b placeObjectInBoard:obj];
    }
    return b;
}

- (void) clearBoard {
    self.board = [NSMutableArray arrayWithCapacity:self.columnCount];
    for (int i = 0; i < self.columnCount; i++) {
        NSMutableArray * col = [NSMutableArray arrayWithCapacity:self.rowCount];
        [self.board addObject:col];
        for (int j = 0; j < self.rowCount; j++) {
            [col addObject:[NSNull null]];
        }
    }
}

- (void) placeObjectInBoard:(GameObject *)obj {
    NSMutableArray * col = [self getColForIndex:obj.position.x];
    [col replaceObjectAtIndex:obj.position.y withObject:obj];
}

- (void) removeObjectFromBoard:(GameObject *)obj {
    NSMutableArray * col = [self getColForIndex:obj.position.x];
    [col replaceObjectAtIndex:obj.position.y withObject:[NSNull null]];
}

- (GameObject *) getObjectAtX:(int)x y:(int)y {
    NSMutableArray * col = [self getColForIndex:x];
    NSObject * obj = [col objectAtIndex:y];
    return (obj == [NSNull null]) ? nil : (GameObject *) obj;
}

- (NSMutableArray *) getColForIndex:(int)index { return [self.board objectAtIndex:index]; }

@end
