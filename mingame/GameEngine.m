//
//  GameEngine.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameEngine.h"
#import "GameBoard.h"
#import "GameLevel.h"
#import "GameRenderer.h"
#import "LevelSerializer.h"

@interface GameEngine()

@property (strong) NSMutableArray * objects;
@property (strong) GameBoard * board;

@property (strong) NSMutableArray * levels;
@property (weak) GameLevel * currentLevel;
@property int levelIndex;

@property int gfxScale;

@property (strong) NSMutableArray * playerKeys;

@property (strong) UIImageView * imageView;

@end

@implementation GameEngine

- (instancetype)initWithImageView:(UIImageView *)imageView {
    self = [super init];
    if (self) {
        self.gfxScale = 20;
        self.playerKeys = [NSMutableArray array];
        self.imageView = imageView;
        self.levelIndex = 0;
        self.levels = [NSMutableArray array];
        //max level is 16 x 30
        [self createLevels];
        [self resetLevel];
    }
    return self;
}

- (void) createLevels {
    //level 1 introduces player and end
    NSString * levelString = [NSString stringWithFormat:@""
        "WWWWWX"
        "W   WX"
        "W E WX"
        "W   WX"
        "W   WX"
        "W   WX"
        "W   WX"
        "W P WX"
        "W   WX"
        "WWWWWX"
    ];
    [self.levels addObject:[LevelSerializer deserializeLevelFromString:levelString]];
    
    //level 2, introduces key and doors
    levelString = [NSString stringWithFormat:@""
        "WWWWWX"
        "W   WX"
        "W E WX"
        "W   WX"
        "WW6WWX"
        "W   WX"
        "W   WX"
        "W P WX"
        "W   WX"
        "W   WX"
        "W 3 WX"
        "W   WX"
        "WWWWWX"
    ];
    [self.levels addObject:[LevelSerializer deserializeLevelFromString:levelString]];
    
    //level 3, introduces colored key and doors
    levelString = [NSString stringWithFormat:@""
       "WWWWWWWWWWWX"
       "W         WX"
       "W    E    WX"
       "W         WX"
       "WWWWW4WWWWWX"
       "   W   WX"
       "   W   WX"
       "   W P WX"
       "WWWW   WWWWX"
       "W         WX"
       "W 1  2  3 WX"
       "W         WX"
       "WWWWWWWWWWWX"
   ];
    [self.levels addObject:[LevelSerializer deserializeLevelFromString:levelString]];
    
    
    //level 4, first real puzzle w/ colored keys and doors
    levelString = [NSString stringWithFormat:@""
        "     WWWWWX"
        "     W   WX"
        "     W E WX"
        "     W   WX"
        "WWWWWWW5WWWWWWWX"
        "W    W   W    WX"
        "W 3  4 1 4  2 WX"
        "W    W   W    WX"
        "WWWWWWW4WWWWWWWX"
        "     W   WX"
        "     W P WX"
        "     W   WX"
        "     W 1 WX"
        "     W   WX"
        "     WWWWWX"
    ];
    [self.levels addObject:[LevelSerializer deserializeLevelFromString:levelString]];
    
    //level 5, introduces a monster
    levelString = [NSString stringWithFormat:@""
       "WWWWWX"
       "W   WX"
       "W E WX"
       "W   WX"
       "W M WX"
       "W   WX"
       "W   WX"
       "W P WX"
       "W   WX"
       "WWWWWX"
   ];
    [self.levels addObject:[LevelSerializer deserializeLevelFromString:levelString]];
            
}

- (void) movePlayerByOffsetx:(int)x yOffset:(int)y {
    CGPoint oldPoint = self.currentLevel.player.position;
    int colCount = self.board.columnCount;
    int rowCount = self.board.rowCount;
    int newX = (oldPoint.x == 0 && x < 0) ? 0 : MIN(oldPoint.x + x, colCount);
    int newY = (oldPoint.y == 0 && y < 0) ? 0 : MIN(oldPoint.y + y, rowCount);
    
    if (![self canPlayerMoveToLocationX:newX y:newY]) {
        return;
    }
    
    CGPoint newPosition = CGPointMake(newX, newY);
    if ([self isMonsterAtPosition:newPosition]) {
        [self resetLevel];
        return;
    }
    if ([self isLevelCompletedAtPosition:newPosition]) {
        [self moveToNextLevel];
        return;
    }
    [self checkForKeyAtPosition:newPosition];
    [self checkForDoorAtPosition:newPosition];
    
    [self moveObject:self.currentLevel.player x:newX y:newY];
    [self draw];
    
}

- (bool) canPlayerMoveToLocationX:(int)x y:(int)y {
    GameObject * existingObj = [self.board getObjectAtX:x y:y];
    if (existingObj == nil) {
        return true;
    }
    if (existingObj.identifier.type == GAMEOBJECTTYPE_WALL) {
        return false;
    }
    if (existingObj.identifier.type == GAMEOBJECTTYPE_DOOR) {
        return [self getKeyForDoor:existingObj] != nil;
    }
    return true;
}

- (GameObject *) getKeyForDoor:(GameObject*)door {
    for (GameObject * o in self.playerKeys) {
        if (o.identifier.variant == door.identifier.variant) {
            return o;
        }
    }
    return nil;
}

- (void) moveToNextLevel {
    self.levelIndex += 1;
    if (self.levelIndex == [self.levels count]) {
        self.levelIndex = 0;
    }
    [self resetLevel];
}

- (void) resetLevel {
    self.currentLevel = [self.levels objectAtIndex:self.levelIndex];
    [self.currentLevel resetObjectPositions];
    self.objects = [self.currentLevel getObjects];
    self.playerKeys = [NSMutableArray array];
    self.board = [GameBoard createBoardForLevel:self.currentLevel];
    [self draw];
}

- (void) draw {
    CGRect frame = self.imageView.frame;
    //do the heavy lifting of the graphics work on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{        
        //TODO: make this a three-phase process where walls are drawn once, then that is used as the start image over and over
        //TODO: make the second phase draw static items (doors, keys), but on a second image that can be redrawn once in a while based on the wall image
        //TODO: make third phase draw moving objects (monsters / players)
        UIGraphicsBeginImageContext(frame.size);
        int scale = self.gfxScale;
        for (GameObject * obj in self.objects) {
            [[obj getCurrentSprite] drawInRect:CGRectMake(obj.position.x * scale, obj.position.y * scale, scale, scale)];
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageView.image = newImage;
        });
    });
}

- (bool) isMonsterAtPosition:(CGPoint)position {
    return [self checkForObjectAtPosition:position type:GAMEOBJECTTYPE_MONSTER];
}

- (void) checkForKeyAtPosition:(CGPoint)position {
    if ([self checkForObjectAtPosition:position type:GAMEOBJECTTYPE_KEY]) {
        GameObject * key = (GameObject *) [self.board getObjectAtX:position.x y:position.y];
        [self.playerKeys addObject:key];
        [self removeObjectAtPosition:position];
    }
}

- (void) checkForDoorAtPosition:(CGPoint)position {
    if ([self checkForObjectAtPosition:position type:GAMEOBJECTTYPE_DOOR]) {
        GameObject * door = (GameObject *) [self.board getObjectAtX:position.x y:position.y];
        GameObject * key = [self getKeyForDoor:door];
        if (key != nil) {
            [self.playerKeys removeObject:key];
            [self removeObjectAtPosition:position];
        }
    }
}

- (void) removeObjectAtPosition:(CGPoint)position {
    GameObject * obj = [self.board getObjectAtX:position.x y:position.y];
    if (obj == nil) {
        return;
    }
    [self removeObject:obj];
}

- (bool) checkForObjectAtPosition:(CGPoint)position type:(GameObjectType)type {
    NSObject * obj = [self.board getObjectAtX:position.x y:position.y];
    if (obj == [NSNull null]) {
        return false;
    }
    if (((GameObject *) obj).identifier.type == type) {
        return true;
    }
    return false;
}

- (bool) isLevelCompletedAtPosition:(CGPoint)position {
    return [self checkForObjectAtPosition:position type:GAMEOBJECTTYPE_END];
}

- (void) moveObject:(GameObject *)obj x:(int)x y:(int)y {
    [self.board removeObject:obj];
    obj.position = CGPointMake(x, y);
    [self.board placeObject:obj];
}

- (void) addObject:(GameObject *)obj {
    [self.objects addObject:obj];
    [self.board placeObject:obj];
}

- (void) removeObject:(GameObject *)obj {
    [self.objects removeObject:obj];
    [self.board removeObject:obj];
}

@end
