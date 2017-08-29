//
//  ViewController.h
//  mingame
//
//  Created by Jason Baker on 8/27/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConfig.h"

@interface ViewController : UIViewController

@property (strong) IBOutlet UIImageView * imageView;

@property (strong) GameConfig * game;

- (IBAction) imageTouched:(id)sender;

@end

