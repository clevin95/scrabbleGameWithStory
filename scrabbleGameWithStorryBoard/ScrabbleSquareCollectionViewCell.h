//
//  ScrabbleSquareCollectionViewCell.h
//  scrabbleGameWithStorryBoard
//
//  Created by swift on 6/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrabbleSquareCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *letterLabel;
@property (nonatomic) BOOL hasBeenTapped;

@end
