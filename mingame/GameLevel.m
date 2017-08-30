//
//  GameLevel.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameLevel.h"

@interface GameLevel()

@property NSMutableArray * objects;

@end


@implementation GameLevel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.height = 0;
        self.width = 0;
        self.objects = [NSMutableArray array];
    }
    return self;
}

- (void) resetObjectPositions {
    for (GameObject * obj in self.objects) {
        [obj resetToOriginalPosition];
    }
}

- (void) addObject:(GameObject *)obj {
    if (obj.identifier.type == GAMEOBJECTTYPE_PLAYER) {
        self.player = obj;
    }
    if (obj.identifier.type == GAMEOBJECTTYPE_END) {
        self.end = obj;
    }
    if (obj.position.x >= self.width) {
        self.width = obj.position.x + 1;
    }
    if (obj.position.y >= self.height) {
        self.height = obj.position.y + 1;
    }
    [self.objects addObject:obj];
}

- (NSMutableArray *) getObjects {
    return [NSMutableArray arrayWithArray:self.objects];
}

@end
