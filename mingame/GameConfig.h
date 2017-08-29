//
//  GameConfig.h
//  mingame
//
//  Created by Jason Baker on 8/28/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameBoard.h"

@interface GameConfig : NSObject

@property (strong) GameBoard * board;

@property (strong) GameObject * player;
@property (strong) GameObject * end;
@property (strong) GameObject * door;
@property (strong) GameObject * key;

@property int level;
@property int playerKeyCount;

- (bool) isGameOver;
- (void) moveToNextLevel;
- (void) checkForDoor;
- (void) checkForKey;

@end
