//
//  GameConfig.m
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameConfig.h"

@implementation GameConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        self.playerKeyCount = 0;
        self.board = [[GameBoard alloc] init];
        self.board.config = self;
        
        self.player = [[GameObject alloc] init];
        [self.player setUIImageBackgroundColor:[UIColor redColor]];
        [self.board addObjectToBoard:self.player];
        
        
        self.end = [[GameObject alloc] init];
        [self.end setUIImageBackgroundColor:[UIColor greenColor]];
        [self.board addObjectToBoard:self.end];
        
        self.door = [[GameObject alloc] init];
        [self.door setUIImageBackgroundColor:[UIColor brownColor]];
        
        self.key = [[GameObject alloc] init];
        [self.key setUIImageBackgroundColor:[UIColor yellowColor]];
        
        [self moveToNextLevel];
    }
    return self;
}

- (void) moveToNextLevel {
    [self.board clearBoard];
    self.playerKeyCount = 0;
    self.level += 1;
    if (self.level == 3) {
        self.level = 1;
    }
    int maxX = 5;
    int maxY = (self.level == 1) ? 10 : 13;
    
    if (self.level == 1 || self.level == 2) {
        
        [self.board moveObject:self.end x:12 y:12];
        [self.board moveObject:self.player x:12 y:17];
        
        [self.board addObjectToBoard:self.player];
        [self.board addObjectToBoard:self.end];
        
        for (int x = 0; x < maxX; x++) {
            for (int y = 0; y < maxY; y++) {
                if (y != 0 && y != (maxY - 1)) {
                    if (x != 0 && x != (maxX - 1)) {
                        continue;
                    }
                }
                GameObject * wall = [[GameObject alloc] init];
                [wall setUIImageBackgroundColor:[UIColor blackColor]];
                wall.position = CGPointMake(x + 10, y + 10);
                [self.board addObjectToBoard:wall];
            }
        }
    }
    
    if (self.level == 2) {
        for (int x = 0; x < maxX; x++) {
            if (x == 2) {
                continue;
            }
            GameObject * wall = [[GameObject alloc] init];
            [wall setUIImageBackgroundColor:[UIColor blackColor]];
            wall.position = CGPointMake(x + 10, 14);
            [self.board addObjectToBoard:wall];
        }
        
        self.door.position = CGPointMake(12,14);
        [self.board addObjectToBoard:self.door];
        
        self.key.position = CGPointMake(12,20);
        [self.board addObjectToBoard:self.key];
    }
}

- (void) checkForKey {
    bool playerIsOverKey = (self.player.position.x == self.key.position.x) && (self.player.position.y == self.key.position.y);
    if (playerIsOverKey) {
        self.playerKeyCount += 1;
        [self.board removeObjectFromBoard:self.key];
    }
}

- (void) checkForDoor {
    bool playerIsOverDoor = (self.player.position.x == self.door.position.x) && (self.player.position.y == self.door.position.y);
    if (playerIsOverDoor) {
        self.playerKeyCount -= 1;
        [self.board removeObjectFromBoard:self.door];
    }
}

- (bool) isGameOver {
    return (self.player.position.x == self.end.position.x) && (self.player.position.y == self.end.position.y);
}

@end
