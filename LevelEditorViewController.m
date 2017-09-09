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
#import "ViewController.h"
#import "LevelSerializer.h"

@interface LevelEditorViewController ()

@property (strong) LevelEditor * levelEditor;
@property (strong) UIImage * gridImage;
@property CGPoint touchStartPosition;
@property CGPoint touchStopPosition;
@property int columnCount;
@property int rowCount;
@property int tileLength;
@property (strong) GameObjectSelectionPopup * objectPopup;
@property (strong) ModeSelectionPopup * modePopup;

@end

@implementation LevelEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.columnCount = 13;
    self.rowCount = 22;
    self.tileLength = 26;
    
    if (self.level == nil) {
        self.level = [[GameLevel alloc] init];
        self.level.width = self.columnCount;
        self.level.height = self.rowCount;
        GameConfig * cfg = [GameConfig sharedInstance];
        GameObject * player = [cfg createObjectWithType:GAMEOBJECTTYPE_PLAYER];
        player.position = CGPointMake(6, 12);
        player.originalPosition = player.position;
        [self.level addObject:player];
        
        GameObject * end = [cfg createObjectWithType:GAMEOBJECTTYPE_END];
        end.position = CGPointMake(6, 7);
        end.originalPosition = end.position;
        [self.level addObject:end];
    }
    self.levelEditor = [[LevelEditor alloc] initWithLevel:self.level];
    
    self.objectPopup = [[GameObjectSelectionPopup alloc] init];
    self.objectPopup.buttonDelegate = self;
    [self.objectPopup setHidden:true];
    self.objectPopup.frame = [TOFrameUtils frame:self.objectPopup.frame centerInFrame:self.view.frame];
    [self.view addSubview:self.objectPopup];
    [self.objectPopup frameCenterInParent];
    
    self.modePopup = [[ModeSelectionPopup alloc] init];
    self.modePopup.buttonDelegate = self;
    self.modePopup.currentObject = self.levelEditor.currentObject;
    [self.modePopup updateButtonFromCurrentObject];
    [self.view addSubview:self.modePopup];
    [self.modePopup frameCenterInParent];
    [self.modePopup frameMoveToY:(self.view.frame.size.height - self.modePopup.frame.size.height)];
    
    self.touchStartPosition = CGPointMake(-1, -1);
    self.touchStopPosition = CGPointMake(-1, -1);
    
    self.gridImage = [GameRenderer renderGrid:[UIColor whiteColor]
                                  borderColor:[UIColor grayColor] borderWidth:1
                                   tileHeight:self.tileLength tileWidth:self.tileLength
                                  columnCount:self.columnCount rowCount:self.rowCount];
        
    int x = (self.view.frame.size.width - self.gridImage.size.width) / 2;
    self.imageView.frame = CGRectMake(x, x, self.gridImage.size.width, self.gridImage.size.height);
    [self draw];
}

- (void)handleButtonClickData:(NSObject *)data selectionPopup:(ItemSelectionPopup *)selectionPopup {
    if (selectionPopup == self.modePopup) {
        if ([@"object" isEqualToString:(NSString *) data]) {
            [self.objectPopup setHidden:false];
        } else if ([@"play" isEqualToString:(NSString *)data]) {
            ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gamevc"];
            vc.level = self.levelEditor.level;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([@"save" isEqualToString:(NSString *)data]) {
            GameConfig * cfg = [GameConfig sharedInstance];
            if (![cfg.userLevels containsObject:self.levelEditor.level]) {
                [cfg.userLevels addObject:self.levelEditor.level];
            }
            [cfg saveConfig];
            [self.navigationController popViewControllerAnimated:YES];
        } else if ([@"trash" isEqualToString:(NSString *)data]) {
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@""
                                         message:@"Are you sure?"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            GameConfig * cfg = [GameConfig sharedInstance];
                                            [cfg.userLevels removeObject:self.levelEditor.level];
                                            [cfg saveConfig];
                                            [self.navigationController popViewControllerAnimated:YES];
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {}];
            
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if ([@"share" isEqualToString:(NSString *)data]) {
            NSString * serializedLevel = [LevelSerializer serializeLevel:self.levelEditor.level];
            NSString * url = [NSString stringWithFormat:@"mingame://level=%@", serializedLevel];
            NSArray * activityItems = @[[NSString stringWithFormat:@"Check out this level I made in mingame.\n\n%@", url]/*, [NSURL URLWithString:url]*/];
            NSArray * applicationActivities = nil;
            NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr, UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
            
            UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
            activityController.excludedActivityTypes = excludeActivities;
            [activityController setValue:@"I made a mingame level!" forKey:@"subject"];
            
            [self presentViewController:activityController animated:YES completion:nil];
        }
    } else { // game menu popup
        [self.objectPopup setHidden:true];
        GameObject * obj = (GameObject *) data;
        if (obj != nil && obj.identifier.type == GAMEOBJECTTYPE_SPACE) {
            obj = nil;
        }
        
        self.modePopup.currentObject = obj;
        self.levelEditor.currentObject = obj;
        [self.modePopup updateButtonFromCurrentObject];
    }
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStartPosition = [self getObjectCoordinatesFromTouches:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStopPosition = [self getObjectCoordinatesFromTouches:touches];
    [self placeObjects];
    [self.levelEditor removeTemporaryObjects];
    //NSLog(@"Touches moved: %d %d", (int) self.touchStopPosition.x, (int) self.touchStopPosition.y);
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.touchStopPosition = [self getObjectCoordinatesFromTouches:touches];
    [self placeObjects];
    [self.levelEditor saveTemporaryObjects];
    //NSLog(@"Touches ended: %d %d", (int) self.touchStopPosition.x, (int) self.touchStopPosition.y);
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
    int startY = MIN(self.touchStartPosition.y, self.touchStopPosition.y);
    int stopX = MAX(self.touchStartPosition.x, self.touchStopPosition.x);
    int stopY = MAX(self.touchStartPosition.y, self.touchStopPosition.y);
    if (self.levelEditor.currentObject.identifier.type == GAMEOBJECTTYPE_PLAYER) {
        [self.levelEditor placeObjectAtX:stopX y:stopY temporary:false];
    } else {
        bool fill = self.levelEditor.currentObject == nil;
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
    }
    [self draw];
}

- (CGPoint) getObjectCoordinatesFromPosition:(CGPoint)position {
    int posX = (int) position.x;
    int posY = (int) position.y;
    //width of tile * number of tiles + size of borders between tiles + outside border size
    int xUpperBound = (self.tileLength * self.columnCount) + (self.columnCount + 2);
    int yUpperBound = (self.tileLength * self.rowCount) + (self.rowCount + 2);
    if (posX < 0 || posY < 0 || posX > xUpperBound || posY > yUpperBound) {
        return CGPointMake(-1, -1);
    }
    for (int x = 0; x < self.columnCount; x++) {
        int xLowerBound = (x * self.tileLength) + (x + 1);
        xUpperBound = xLowerBound + self.tileLength;
        if (posX < xLowerBound || posX > xUpperBound) {
            continue;
        }
        for (int y = 0; y < self.rowCount; y++) {
            int yLowerBound = (y * self.tileLength) + (y + 1);
            yUpperBound = yLowerBound + self.tileLength;
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
                                                tileLength:self.tileLength borderWidth:1
                                               columnCount:self.columnCount rowCount:self.rowCount];
}

@end
