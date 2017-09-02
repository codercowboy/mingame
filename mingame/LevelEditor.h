//
//  LevelEditor.h
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameLevel.h"

@interface LevelEditor : NSObject

@property (strong) GameLevel * level;

- (void) placeObjectAtX:(int)x y:(int)y temporary:(bool)temporary;
- (void) removeObjectAtX:(int)x y:(int)y;
- (void) saveTemporaryObjects;
- (void) removeTemporaryObjects;

@end
