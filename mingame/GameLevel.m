//
//  GameLevel.m
//  mingame
//
//  Created by Jason Baker on 8/29/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "GameLevel.h"

@implementation GameLevel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray array];
        
        self.player = [GameObject createWithType:PLAYER position:CGPointMake(12, 17) sprite:nil];
        [self.player setUIImageBackgroundColor:[UIColor redColor]];
        [self.objects addObject:self.player];
        
        self.end = [GameObject createWithType:END position:CGPointMake(12,12) sprite:nil];
        [self.end setUIImageBackgroundColor:[UIColor greenColor]];
        [self.objects addObject:self.end];
    }
    return self;
}

- (void) resetObjectPositions {
    for (GameObject * obj in self.objects) {
        [obj resetToOriginalPosition];
    }
}

@end
