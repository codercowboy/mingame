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
        [b placeObject:obj];
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

- (void) placeObject:(GameObject *)obj {
    NSMutableArray * col = [self getColForIndex:obj.position.x];
    [col replaceObjectAtIndex:obj.position.y withObject:obj];
}

- (void) placeObject:(GameObject *)obj x:(int)x y:(int)y {
    NSMutableArray * col = [self getColForIndex:x];
    NSObject * nilSafeObj = (obj == nil) ? [NSNull null] : obj;
    [col replaceObjectAtIndex:obj.position.y withObject:nilSafeObj];
}

- (void) removeObjectAtX:(int)x y:(int)y {
    NSMutableArray * col = [self getColForIndex:x];
    [col replaceObjectAtIndex:y withObject:[NSNull null]];
}

- (void) removeObject:(GameObject *)obj {
    if (obj == nil) {
        return;
    }
    [self removeObjectAtX:obj.position.x y:obj.position.y];
}

- (GameObject *) getObjectAtX:(int)x y:(int)y {
    NSMutableArray * col = [self getColForIndex:x];
    NSObject * obj = [col objectAtIndex:y];
    return (obj == [NSNull null]) ? nil : (GameObject *) obj;
}

- (NSMutableArray *) getColForIndex:(int)index { return [self.board objectAtIndex:index]; }

@end
