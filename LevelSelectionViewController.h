//
//  LevelSelectionViewController.h
//  mingame
//
//  Created by Jason Baker on 9/6/17.
//  Copyright © 2017 Jason Baker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelectionCell : UICollectionViewCell
- (void) update;
@end

@interface LevelSelectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong) IBOutlet UICollectionView * collectionView;
@end
