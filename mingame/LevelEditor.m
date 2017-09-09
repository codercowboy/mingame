//
//  LevelEditor.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "LevelEditor.h"
#import "GameConfig.h"
#import "GameBoard.h"

@interface LevelEditor();

@property (strong) GameBoard * board;
@property (strong) NSMutableArray * temporaryObjects;

@end

@implementation LevelEditor

- (instancetype)init {
    self = [super init];
    if (self) {
        self.level = [[GameLevel alloc] init];
        GameConfig * cfg = [GameConfig sharedInstance];
        self.currentObject = [cfg createObjectWithType:GAMEOBJECTTYPE_WALL
                                               variant:GAMEOBJECTVARIANT_UNDEFINED positionX:0 positionY:0];
        self.board = [[GameBoard alloc] initWithColumnCount:16 rowCount:30];
        self.temporaryObjects = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithLevel:(GameLevel*)level {
    self = [super init];
    if (self) {
        level.width = 16;
        level.height = 30;
        self.level = level;
        GameConfig * cfg = [GameConfig sharedInstance];
        self.currentObject = [cfg createObjectWithType:GAMEOBJECTTYPE_WALL
                                               variant:GAMEOBJECTVARIANT_UNDEFINED positionX:0 positionY:0];
        self.board = [GameBoard createBoardForLevel:level];
        self.temporaryObjects = [NSMutableArray array];
    }
    return self;
}

- (void) placeObjectAtX:(int)x y:(int)y temporary:(bool)temporary {
    if (self.currentObject == nil) {
        [self removeObjectAtX:x y:y];
        return;
    }
    
    //remove pre-existing player objects
    if (self.currentObject.identifier.type == GAMEOBJECTTYPE_PLAYER) {
        for (GameObject * o in [self.level getObjects]) {
            if (o.identifier.type == GAMEOBJECTTYPE_PLAYER) {
                [self.temporaryObjects removeObject:o];
                [self.level removeObject:o];
                [self.board removeObject:o];
            }
        }
    }
    
    GameObject * obj = [self.currentObject clone];
    obj.position = CGPointMake(x,y);
    obj.originalPosition = obj.position;
    if (temporary) {
        [self.temporaryObjects addObject:obj];
    }
    [self.level addObject:obj];
    [self.board placeObject:obj x:x y:y];
}

- (void) removeObjectAtX:(int)x y:(int)y {
    [self.board removeObjectAtX:x y:y];
    [self.level removeObjectAtX:x y:y];
}

- (void) saveTemporaryObjects {
    self.temporaryObjects = [NSMutableArray array];
}

- (void) removeTemporaryObjects {
    for (GameObject * obj in self.temporaryObjects) {
        [self.board removeObject:obj];
        [self.level removeObject:obj];
    }
    self.temporaryObjects = [NSMutableArray array];
}

@end
