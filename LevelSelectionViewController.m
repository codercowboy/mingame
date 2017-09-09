//
//  LevelSelectionViewController.m
//  mingame
//
//  Created by Jason Baker on 9/6/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import "LevelSelectionViewController.h"
#import "LevelEditorViewController.h"
#import "ViewController.h"
#import "GameEngine.h"
#import "GameRenderer.h"

@interface LevelSelectionCell()

@property (strong) UIImageView * imageView;
@property (strong) GameLevel * level;

@end

@implementation LevelSelectionCell

- (void) update {
    if (self.imageView == nil) {
        int side = self.frame.size.width;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0f;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //TODO: make this a three-phase process where walls are drawn once, then that is used as the start image over and over
        //TODO: make the second phase draw static items (doors, keys), but on a second image that can be redrawn once in a while based on the wall image
        //TODO: make third phase draw moving objects (monsters / players)
        UIImage * image = [GameRenderer renderGameObjects:[self.level getObjects] backgroundImage:nil tileLength:20 borderWidth:0
                                              columnCount:self.level.width rowCount:self.level.height];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.imageView.image = image;
        });
    });
}

@end


@interface LevelSelectionViewController ()

@property bool editMode;
@property (strong) NSMutableArray * levels;
@end

@implementation LevelSelectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void) viewDidLoad {
    [super viewDidLoad];
    self.editMode = false;
    //self.levels = [NSMutableArray arrayWithArray:[GameEngine createLevels]];
    self.levels = [GameConfig sharedInstance].userLevels;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[LevelSelectionCell class] forCellWithReuseIdentifier:@"levelSelectionCell"];
    
    UILongPressGestureRecognizer * longGesture = [[UILongPressGestureRecognizer alloc] init];
    [longGesture addTarget:self action:@selector(handleLongPressGesture:)];
    [self.collectionView addGestureRecognizer:longGesture];    
}

- (void) viewWillAppear:(BOOL)animated {
    self.levels = [GameConfig sharedInstance].userLevels;
    [self.collectionView reloadData];
}

- (void) updateFromConfig {
    [self.collectionView reloadData];
}

-(void) handleLongPressGesture:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath=[self.collectionView indexPathForItemAtPoint:[gesture locationInView:self.collectionView]];
        if (indexPath != nil) {
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        [self.collectionView updateInteractiveMovementTargetPosition:[gesture locationInView:self.collectionView]];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.collectionView endInteractiveMovement];
    } else {
        [self.collectionView cancelInteractiveMovement];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.levels count];
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"levelSelectionCell";
    LevelSelectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.level = [self.levels objectAtIndex:indexPath.item];
    [cell update];
    return cell;
}

- (IBAction) toggleEditMode {
    self.editMode = !self.editMode;
}

- (IBAction) addLevel {
    LevelEditorViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"leveleditorvc"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be selected
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL) collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL) collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (BOOL) collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    //return self.editMode;
    return YES;
}

- (void) collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
//    NSLog(@"moved from %d to %d", sourceIndexPath.item, destinationIndexPath.item);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  //  NSLog(@"selected: %d", indexPath.item);
    LevelEditorViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"leveleditorvc"];
    //ViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"gamevc"];
    vc.level = [self.levels objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
