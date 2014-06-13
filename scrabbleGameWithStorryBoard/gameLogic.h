//
//  gameLogic.h
//  scrabbleGameWithStorryBoard
//
//  Created by swift on 6/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface gameLogic : NSObject

@property (strong, nonatomic) NSMutableArray *selectedLetters;
@property (strong, nonatomic) NSArray *alphabet;
@property (nonatomic) NSInteger cardsInPlay;
@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSMutableArray *lettersInPlay;
-(NSString *)getRandomLetter;
-(BOOL)isDictionaryWord:(NSString*)word;
-(void)updateSore;

-(NSMutableArray *)largestRealWord:(NSMutableArray *)lettersToAdd
                   withCount:(NSInteger)count;
@end
