//
//  GameConfig.h
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

@interface GameConfig : NSObject

//UIColor defaults of these are neon garbage, changing them..
@property (strong) UIColor * purpleColor;
@property (strong) UIColor * greenColor;
@property (strong) UIColor * blueColor;
@property (strong) UIColor * redColor;
@property (strong) UIColor * orangeColor;
@property (strong) UIColor * pinkColor;
@property (strong) UIColor * backgroundColor;

@property (strong) UIColor * playerColor;
@property (strong) UIColor * wallColor;
@property (strong) UIColor * keyColor;
@property (strong) UIColor * doorColor;
@property (strong) UIColor * endColor;
@property (strong) UIColor * monsterColor;

@property (strong) NSMutableArray * userLevels;

+ (GameConfig *) sharedInstance;
- (GameObject *) createObjectWithType:(GameObjectType)type;
- (GameObject *) createObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant;
- (GameObject *) createObjectWithType:(GameObjectType)type variant:(GameObjectVariant)variant positionX:(int)x positionY:(int)y;
- (void) saveConfig;

@end
