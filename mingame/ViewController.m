//
//  ViewController.m
//  mingame
//
//  Created by Jason Baker on 8/27/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import "GameEngine.h"

@interface ViewController ()

@property (strong) GameEngine * gameEngine;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [GameConfig sharedInstance].backgroundColor;
    self.imageView.backgroundColor = [GameConfig sharedInstance].backgroundColor;
    
    self.gameEngine = [[GameEngine alloc] initWithImageView:self.imageView];
    
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(draw) userInfo:nil repeats:YES];
    UISwipeGestureRecognizer * rec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftSwipe)];
    [rec setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self view] addGestureRecognizer:rec];
    
    rec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe)];
    [rec setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self view] addGestureRecognizer:rec];
    
    rec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleUpSwipe)];
    [rec setDirection:UISwipeGestureRecognizerDirectionUp];
    [[self view] addGestureRecognizer:rec];
    
    rec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleDownSwipe)];
    [rec setDirection:UISwipeGestureRecognizerDirectionDown];
    [[self view] addGestureRecognizer:rec];
    
}

-(void)handleLeftSwipe { [self.gameEngine movePlayerByOffsetx:-1 yOffset:0]; }
-(void)handleRightSwipe { [self.gameEngine movePlayerByOffsetx:1 yOffset:0]; }
-(void)handleUpSwipe { [self.gameEngine movePlayerByOffsetx:0 yOffset:-1]; }
-(void)handleDownSwipe { [self.gameEngine movePlayerByOffsetx:0 yOffset:1]; }

@end
