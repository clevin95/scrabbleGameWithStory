//
//  gameLogic.m
//  scrabbleGameWithStorryBoard
//
//  Created by swift on 6/12/14.
//  Copyright (c) 2014 swift. All rights reserved.
//

#import "gameLogic.h"
#import "AppDelegate.h"

@implementation gameLogic

-(NSString *)convertArrayToString:(NSArray *)letterArray
{
    NSMutableString *outputString = [[NSMutableString alloc]initWithString:@""];
    for (NSString *letter in letterArray){
        [outputString appendString:letter];
    }
    return [outputString lowercaseString];
}


-(NSMutableArray *)largestRealWord:(NSMutableArray *)lettersToAdd
                         withCount:(NSInteger)count
{
    NSMutableArray *allSwapsForCount = [self allEllemensIn:lettersToAdd moveToIndex:count];
    if (count == [lettersToAdd count] + 1){
        if ([self isDictionaryWord:[self convertArrayToString:lettersToAdd]]){
            return lettersToAdd;
        }else{
            return nil;
        }
    }
    for (NSMutableArray *newSwap in allSwapsForCount){
        [self largestRealWord:newSwap withCount:count + 1];
    }
    return allSwapsForCount;
}

-(NSMutableArray *)allEllemensIn:(NSMutableArray *)letterArray
                     moveToIndex:(NSInteger)index
{
    NSMutableArray *outputArray = [[NSMutableArray alloc]init];
    for (NSInteger i = index + 1; i < [letterArray count]; i++){
        NSMutableArray *newCombination = [letterArray mutableCopy];
        [newCombination exchangeObjectAtIndex:index withObjectAtIndex:i];
        [outputArray addObject:newCombination];
    }
    [outputArray addObject:letterArray];
    return outputArray;
}





-(NSMutableArray *)selectedLetters
{
    if (!_selectedLetters){
        _selectedLetters = [[NSMutableArray alloc]init];
    }
    return _selectedLetters;
}

-(NSMutableArray *)lettersInPlay
{
    if (!_lettersInPlay){
        _lettersInPlay = [[NSMutableArray alloc]init];
    }
    return _lettersInPlay;
}


+ (NSDictionary *)scrabbleLetterScore
{
    return @{@"A":@1,@"B":@3,@"C":@3,@"D":@2,@"E":@1,@"F":@4,@"G":@2,@"H"\
             :@4,@"I":@1,@"J":@8,@"K":@5,@"L":@1, @"M":@3, @"N":@1, @"O":@1,\
             @"P":@3, @"Q":@10, @"R":@1, @"S":@1, @"T":@1, @"U":@1, @"V":@4,\
             @"W":@4, @"X":@8, @"Y":@4, @"Z":@10};
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alphabet = [@"A B C D E F G H I J K L M N O P Q R S T U V W X Y Z" componentsSeparatedByString:@" "];
        self.cardsInPlay = 16;
        self.score = 0;
    }
    return self;
}

-(NSString *)getRandomLetter
{
    NSInteger randomNumber = arc4random_uniform(25);
    return self.alphabet[randomNumber];
}

-(NSInteger)scoreWord{
    
    NSInteger score = 0;
    NSDictionary *letterScores = [gameLogic scrabbleLetterScore];
    for (NSString *letter in self.selectedLetters){
        score += [letterScores[letter] integerValue];
        
    }
    return score;
}

-(void)updateSore{
    self.score += [self scoreWord];
}


-(BOOL)binarySearchForItem:(NSString *)item
                      From:(NSInteger)start
                        To:(NSInteger)finish
                   inArray:(NSArray *)array
{
    if (start == finish){
        return NO;
    }
    NSInteger middle = ((start - finish) / 2) + start;
    NSString *middleItem = array[middle];
    NSComparisonResult compare = [item compare:middleItem];
    if (compare == NSOrderedSame){
        return YES;
    }else if (compare < NSOrderedAscending){
        return [self binarySearchForItem:item From:start To:middle inArray:array];
    }else{
        return [self binarySearchForItem:item From:middle To:finish inArray:array];
    }
}

-(BOOL)isDictionaryWord:(NSString*) word {
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



@end
