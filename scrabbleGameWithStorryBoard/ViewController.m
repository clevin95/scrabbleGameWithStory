//
//  ViewController.m
//  scrabbleGameWithStorryBoard
//
//  Created by swift on 6/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

#import "ViewController.h"
#import "ScrabbleSquareCollectionViewCell.h"
#import "gameLogic.h"
@interface ViewController () <UICollectionViewDataSource>

@property (strong, nonatomic) gameLogic *logic;
@property (weak, nonatomic) IBOutlet UILabel *resultWord;
@property (weak, nonatomic) IBOutlet UICollectionView *gameBoardCV;
@property (weak, nonatomic) IBOutlet UILabel *playerScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *computerScoreLabel;
@property (strong, nonatomic) NSMutableArray *indexesVisited;

@end

@implementation ViewController

-(gameLogic *)logic
{
    if (!_logic){
        _logic = [[gameLogic alloc]init];
    }
    return _logic;
}


- (void)wipeResultWord{
    self.resultWord.text = @"";
    [self.logic.selectedLetters removeAllObjects];
    self.indexesVisited = [@[] mutableCopy];
}


- (void)updateResultWordWithLetter:(NSString *)letter {
    self.resultWord.text = [self.resultWord.text stringByAppendingString:letter];
}


- (void)regenerateSelected{
    for (NSIndexPath *indexPath in self.indexesVisited){
        UICollectionViewCell *cellToRegenerate = [self.gameBoardCV cellForItemAtIndexPath:indexPath];
        if ([cellToRegenerate isKindOfClass:[ScrabbleSquareCollectionViewCell class]]){
            ScrabbleSquareCollectionViewCell *scrabbleCellToGenerate = (ScrabbleSquareCollectionViewCell *)cellToRegenerate;
            [self updateCell:scrabbleCellToGenerate];
        }
    }
}

/*
- (void)updateCellFonts
{
    for (NSIndexPath *indexPath in self.indexesVisited) {
        UICollectionViewCell *cellToRegenerate = [self.gameBoardCV cellForItemAtIndexPath:indexPath];
        if ([cellToRegenerate isKindOfClass:[ScrabbleSquareCollectionViewCell class]]){
            ScrabbleSquareCollectionViewCell *scrabbleCellToGenerate = (ScrabbleSquareCollectionViewCell *)cellToRegenerate;
            [self updateCell:scrabbleCellToGenerate];
        }
    }
}

*/

- (void)addLetterFromIndex:(NSIndexPath *)indexPath
{
    UICollectionViewCell *selectedCell = [self.gameBoardCV cellForItemAtIndexPath:indexPath];
    if ([selectedCell isKindOfClass:[ScrabbleSquareCollectionViewCell class]]){
        [self.indexesVisited addObject:indexPath];
        
        
        ScrabbleSquareCollectionViewCell *selectedScrabbleCell = (ScrabbleSquareCollectionViewCell *)selectedCell;
        NSString *selectedLetter = selectedScrabbleCell.letterLabel.text;
        selectedScrabbleCell.letterLabel.textColor = [[UIColor alloc]initWithRed:20.0 green:0 blue:0 alpha:1];
        [self.logic.selectedLetters addObject:selectedLetter];
        [self updateResultWordWithLetter:selectedLetter];
    }
}


- (IBAction)cardSelectedWithGesture:(UIGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self.gameBoardCV];
    NSIndexPath *indexPath = [self.gameBoardCV indexPathForItemAtPoint:tapPoint];
    if (indexPath){
        [self addLetterFromIndex:indexPath];
    }
}


- (UICollectionViewCell *)updateCell:(UICollectionViewCell *)cell
{
    ScrabbleSquareCollectionViewCell *scrabbleSquare = (ScrabbleSquareCollectionViewCell *)cell;
    NSString
    *randomLetter = [self.logic getRandomLetter];
    scrabbleSquare.letterLabel.text = randomLetter;
    [self.logic.lettersInPlay addObject:randomLetter];
    return scrabbleSquare;
}


- (void)updatePlayerScoreLabel{
    self.playerScoreLabel.text = [NSString stringWithFormat:@"Your Score: %ld",(long)self.logic.score];
}


- (void)checkWordScore
{
    if ([self.logic isDictionaryWord:self.resultWord.text]){
        self.resultWord.text = @"";
        [self.logic updateSore];
        NSLog(@"%@",[self.logic makeComputerMove]);
        [self regenerateSelected];
        [self wipeResultWord];
    }
    [self updatePlayerScoreLabel];
}

- (IBAction)scoreWordPressed:(id)sender {
    [self checkWordScore];
}

- (IBAction)restartWordPressed:(id)sender {
    [self wipeResultWord];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.logic.cardsInPlay;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"scrabbleBox" forIndexPath:indexPath];
    cell = [self updateCell:cell];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@",[self.logic makeLargestFormLetters:@"ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLMNOPQRSTUVWXYZ"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
}

@end
