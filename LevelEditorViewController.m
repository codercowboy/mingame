//
//  LevelEditorViewController.m
//  mingame
//
//  Created by Jason Baker on 9/1/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "LevelEditorViewController.h"
#import "LevelEditor.h"
#import "GameRenderer.h"

@interface LevelEditorViewController ()

@property (strong) LevelEditor * levelEditor;
@property (strong) UIImage * gridImage;
@property CGPoint touchStartPosition;
@property CGPoint touchStopPosition;

@end

@implementation LevelEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touchStartPosition = CGPointMake(-1, -1);
    self.levelEditor = [[LevelEditor alloc] init];
    self.gridImage = [GameRenderer renderGrid:[UIColor whiteColor]
                                  borderColor:[UIColor grayColor] borderWidth:1
                                   tileHeight:20 tileWidth:20
                                  columnCount:16 rowCount:30];
    [self draw];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStartPosition = [self getObjectCoordinatesFromTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStopPosition = [self getObjectCoordinatesFromTouches:touches];
    [self placeObjects];
    [self.levelEditor removeTemporaryObjects];
    NSLog(@"Touches moved: %d %d", (int) self.touchStopPosition.x, (int) self.touchStopPosition.y);
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStopPosition = [self getObjectCoordinatesFromTouches:touches];
    [self placeObjects];
    [self.levelEditor saveTemporaryObjects];
    NSLog(@"Touches ended: %d %d", (int) self.touchStopPosition.x, (int) self.touchStopPosition.y);
}

- (CGPoint) getObjectCoordinatesFromTouches:(NSSet<UITouch *> *)touches {
    if (touches == nil || [touches count] != 1) {
        return CGPointMake(-1, -1);
    }
    UITouch * touch = [[touches allObjects] objectAtIndex:0];
    return [self getObjectCoordinatesFromPosition:[touch locationInView:self.imageView]];
}

- (void) placeObjects {
    if (self.touchStopPosition.x == -1 || self.touchStartPosition.x == -1
        || self.touchStopPosition.y == -1 || self.touchStartPosition.y == -1) {
        [self draw];
        return;
    }
    int startX = MIN(self.touchStartPosition.x, self.touchStopPosition.x);
    int stopX = MAX(self.touchStartPosition.x, self.touchStopPosition.x);
    int startY = MIN(self.touchStartPosition.y, self.touchStopPosition.y);
    int stopY = MAX(self.touchStartPosition.y, self.touchStopPosition.y);
    bool fill = false;
    for (int x = startX; x <= stopX; x++) {
        for (int y = startY; y <= stopY; y++) {
            if (!fill) {
                if (y != startY && y != stopY
                    && x != startX && x != stopX) {
                    continue;
                }
            }
            [self.levelEditor placeObjectAtX:x y:y temporary:true];
        }
    }
    [self draw];
}

- (CGPoint) getObjectCoordinatesFromPosition:(CGPoint)position {
    int posX = (int) position.x;
    int posY = (int) position.y;
    //width of tile * number of tiles + size of borders between tiles + outside border size
    int xUpperBound = (20 * 16) + (16 + 2);
    int yUpperBound = (20 * 30) + (30 + 2);
    if (posX < 0 || posY < 0 || posX > xUpperBound || posY > yUpperBound) {
        return CGPointMake(-1, -1);
    }
    for (int x = 0; x < 16; x++) {
        int xLowerBound = (x * 20) + (x + 1);
        xUpperBound = xLowerBound + 20;
        if (posX < xLowerBound || posX > xUpperBound) {
            continue;
        }
        for (int y = 0; y < 30; y++) {
            int yLowerBound = (y * 20) + (y + 1);
            yUpperBound = yLowerBound + 20;
            if (posY < yLowerBound || posY > yUpperBound) {
                continue;
            }
            return CGPointMake(x, y);
        }
    }
    return CGPointMake(-1, -1);
}

- (void) draw {
    self.imageView.image = [GameRenderer renderGameObjects:[self.levelEditor.level getObjects] backgroundImage:self.gridImage
                                                tileLength:20 borderWidth:1 columnCount:16 rowCount:30];
}

@end
