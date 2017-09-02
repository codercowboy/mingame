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

@property (strong) GameObject * currentObject;
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

- (void) placeObjectAtX:(int)x y:(int)y temporary:(bool)temporary {
    GameObject * obj = [self.currentObject clone];
    obj.position = CGPointMake(x,y);
    if (temporary) {
        [self.temporaryObjects addObject:obj];
    }
    [self.level addObject:obj];
    [self.board placeObjectInBoard:obj];
}

- (void) removeObjectAtX:(int)x y:(int)y {
    GameObject * obj = [self.board getObjectAtX:x y:y];
    if (obj == nil) {
        return;
    }
    [self.board removeObjectFromBoard:obj];
    [self.level removeObject:obj];
}

- (void) saveTemporaryObjects {
    self.temporaryObjects = [NSMutableArray array];
}

- (void) removeTemporaryObjects {
    for (GameObject * obj in self.temporaryObjects) {
        [self.board removeObjectFromBoard:obj];
        [self.level removeObject:obj];
    }
    self.temporaryObjects = [NSMutableArray array];
}

@end
