//
//  ViewController.m
//  mingame
//
//  Created by Jason Baker on 8/27/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController ()
@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.game = [[GameConfig alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self draw];
    
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

-(void)handleLeftSwipe { [self updateMoveWithXOffset:-1 yOffset:0]; }
-(void)handleRightSwipe { [self updateMoveWithXOffset:1 yOffset:0]; }
-(void)handleUpSwipe { [self updateMoveWithXOffset:0 yOffset:-1]; }
-(void)handleDownSwipe { [self updateMoveWithXOffset:0 yOffset:1]; }

- (void) updateMoveWithXOffset:(int)x yOffset:(int)y {
    [self.game.board moveObjectByOffset:self.game.player xOffset:x yOffset:y];
    [self.game checkForKey];
    [self.game checkForDoor];
    if ([self.game isGameOver]) {
        [self.game moveToNextLevel];
    }
    [self draw];
}

- (void) draw {
    //@autoreleasepool {
    CGRect frame = self.imageView.frame;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
//        UIGraphicsBeginImageContext(CGSizeMake(10, 10));
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
//        CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
//        UIImage * playerImage = UIGraphicsGetImageFromCurrentImageContext();
//        CGContextStrokePath(context);
//        UIGraphicsEndImageContext();
        
//        UIGraphicsBeginImageContext(CGSizeMake(10, 10));
//        UIColor * c = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1.0f];
//        context = UIGraphicsGetCurrentContext();
//        CGContextSetFillColorWithColor(context, [c CGColor]);
//        CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
//        UIImage * smallImage = UIGraphicsGetImageFromCurrentImageContext();
//        CGContextStrokePath(context);
//        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(frame.size);
        
        // Pass 1: Draw the original image as the background
        //[self.imageView.image drawAtPoint:CGPointMake(0,0)];
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (GameObject * obj in self.game.board.objects) {
            [obj.sprite drawInRect:CGRectMake(obj.position.x * 10, obj.position.y * 10, 10, 10)];
        }
        /*
        CGContextSetLineWidth(context, 1.0);
        CGContextMoveToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, frame.size.width, (float)arc4random_uniform(255));
        CGContextSetStrokeColorWithColor(context, [c CGColor]);
        CGContextStrokePath(context);
         */
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageView.image = newImage;
        });
    });
    //}
}

- (IBAction) imageTouched:(id)sender {
    [self draw];
}

@end
