//
//  GameEngine.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameEngine.h"
#import "GameObject.h"
#import "GameBoard.h"
#import "GameLevel.h"

@interface GameEngine()

@property (strong) NSMutableArray * objects;
@property (strong) GameBoard * board;

@property (strong) NSMutableArray * levels;
@property (weak) GameLevel * currentLevel;
@property int levelIndex;

@property int playerKeyCount;

@property int gfxScale;

@property (strong) UIImageView * imageView;

@end

@implementation GameEngine

- (instancetype)initWithImageView:(UIImageView *)imageView {
    self = [super init];
    if (self) {
        self.gfxScale = 20;
        self.imageView = imageView;
        self.levelIndex = 0;
        self.levels = [NSMutableArray array];
        
        [self createLevels];
        [self resetLevel];
    }
    return self;
}

- (void) createLevels {
    for (int lIndex = 0; lIndex < 3; lIndex++) {
        GameLevel * level = [[GameLevel alloc] init];
        [self.levels addObject:level];
        
        int maxX = 5;
        int maxY = (lIndex == 1) ? 13 : 10;
        
        level.player.position = CGPointMake(12, 17);
        level.end.position = CGPointMake(12, 12);
        
        for (int x = 0; x < maxX; x++) {
            for (int y = 0; y < maxY; y++) {
                if (y != 0 && y != (maxY - 1)) {
                    if (x != 0 && x != (maxX - 1)) {
                        continue;
                    }
                }
                GameObject * wall = [GameObject createWithType:WALL position:CGPointMake(x + 10, y + 10) sprite:nil];
                [wall setUIImageBackgroundColor:[UIColor blackColor]];
                [level.objects addObject:wall];
            }
        }
        
        if (lIndex == 1) {
            for (int x = 0; x < maxX; x++) {
                if (x == 2) {
                    continue;
                }
                GameObject * wall = [GameObject createWithType:WALL position:CGPointMake(x + 10, 14) sprite:nil];
                [wall setUIImageBackgroundColor:[UIColor blackColor]];
                [level.objects addObject:wall];
            }
            
            GameObject * door = [GameObject createWithType:DOOR position:CGPointMake(12,14) sprite:nil];
            [door setUIImageBackgroundColor:[UIColor brownColor]];
            [level.objects addObject:door];
            
            GameObject * key = [GameObject createWithType:KEY position:CGPointMake(12,20) sprite:nil];
            [key setUIImageBackgroundColor:[UIColor yellowColor]];
            [level.objects addObject:key];
        }
        
        if (lIndex == 2) {
            GameObject * monster = [GameObject createWithType:MONSTER position:CGPointMake(12,14) sprite:nil];
            [monster setUIImageBackgroundColor:[UIColor orangeColor]];
            [level.objects addObject:monster];
        }
        
        //TODO: when player has powerup, there is an indicator on screen that he has powerup
        //TODO: when player has key, there is an indicator on screen that he has powerup
        
        //TODO: level 4 has two keys of different color (blue/red)
        //TODO: level 5 has a powerup to kill a single monster (wall of monsters must be broken through)
        //TODO: level 6 has two powerups to kill monster (wall of monsters blocks path, then another powerup down a path to the left, then a second wall of monsters blocks path to exit)
        //TODO: level 7 has three powerups to kill monsters, then a triple wall of monsters
        //TODO: level 8 has a rainbow powerup to kill all monsters
        //TODO: level 9 has a moving monster moving left and right
        //TODO: level 10 has a combination of all of the above
        
        //TODO: after user passes level 10, taken to home menu with play button icon for playing starting at tutorial level 1 through all levels, level list button, and level editor button
        //TODO: level editor has way to share levels to friends
    }
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
    NSObject * existingObj = [self.board getObjectAtX:x y:y];
    if (existingObj == [NSNull null]) {
        return true;
    }
    GameObject * existingGameObj = (GameObject *) existingObj;
    if (existingGameObj.type == WALL) {
        return false;
    }
    if (existingGameObj.type == DOOR && self.playerKeyCount > 0) {
        return true;
    }
    return true;
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
    self.objects = [NSMutableArray arrayWithArray:self.currentLevel.objects];
    self.playerKeyCount = 0;
    [self updateBoardFromObjects];
    [self draw];
}

- (void) updateBoardFromObjects {
    self.board = [[GameBoard alloc] initWithColumnCount:25 rowCount:70];
    for (GameObject * obj in self.objects) {
        [self.board placeObjectInBoard:obj];
    }
}

- (void) draw {
    CGRect frame = self.imageView.frame;
    //do the heavy lifting of the graphics work on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //there's some example graphics code over in GameObject.setUIImageBackgroundColor()
        
        //unused line drawing example
//        UIGraphicsBeginImageContext(CGSizeMake(10, 10));
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetLineWidth(context, 1.0);
//        CGContextMoveToPoint(context, 0, 0);
//        CGContextAddLineToPoint(context, frame.size.width, (float)arc4random_uniform(255));
//        UIColor * c = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.0f];
//        CGContextSetStrokeColorWithColor(context, [c CGColor]);
//        CGContextStrokePath(context);
//        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        //TODO: make this a three-phase process where walls are drawn once, then that is used as the start image over and over
        //TODO: make the second phase draw static items (doors, keys), but on a second image that can be redrawn once in a while based on the wall image
        //TODO: make third phase draw moving objects (monsters / players)
        //TODO: move all of thise code out into a GameRenderer
        //TODO: resize image to size needed for level
        UIGraphicsBeginImageContext(frame.size);
        int scale = self.gfxScale;
        for (GameObject * obj in self.objects) {
            [obj.sprite drawInRect:CGRectMake(obj.position.x * scale, obj.position.y * scale, scale, scale)];
        }

        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageView.image = newImage;
        });
    });
}

- (bool) isMonsterAtPosition:(CGPoint)position {
    return [self checkForObjectAtPosition:position type:MONSTER];
}

- (void) checkForKeyAtPosition:(CGPoint)position {
    if ([self checkForObjectAtPosition:position type:KEY]) {
        self.playerKeyCount += 1;
        [self removeObjectAtPosition:position];
    }
}

- (void) checkForDoorAtPosition:(CGPoint)position {
    if ([self checkForObjectAtPosition:position type:DOOR]) {
        self.playerKeyCount -= 1;
        [self removeObjectAtPosition:position];
    }
}

- (void) removeObjectAtPosition:(CGPoint)position {
    NSObject * obj = [self.board getObjectAtX:position.x y:position.y];
    if (obj == [NSNull null]) {
        return;
    }
    [self removeObject:((GameObject *)obj)];
}

- (bool) checkForObjectAtPosition:(CGPoint)position type:(GameObjectType)type {
    NSObject * obj = [self.board getObjectAtX:position.x y:position.y];
    if (obj == [NSNull null]) {
        return false;
    }
    if (((GameObject *) obj).type == type) {
        return true;
    }
    return false;
}

- (bool) isLevelCompletedAtPosition:(CGPoint)position {
    return [self checkForObjectAtPosition:position type:END];
}

- (void) moveObject:(GameObject *)obj x:(int)x y:(int)y {
    [self.board removeObjectFromBoard:obj];
    obj.position = CGPointMake(x, y);
    [self.board placeObjectInBoard:obj];
}

- (void) addObject:(GameObject *)obj {
    [self.objects addObject:obj];
    [self.board placeObjectInBoard:obj];
}

- (void) removeObject:(GameObject *)obj {
    [self.objects removeObject:obj];
    [self.board removeObjectFromBoard:obj];
}

@end
