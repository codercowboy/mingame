//
//  LevelSerializer.h
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameLevel.h"

@interface LevelSerializer : NSObject

+ (GameLevel *) deserializeLevelFromString:(NSString*)encodedLevel;

@end
