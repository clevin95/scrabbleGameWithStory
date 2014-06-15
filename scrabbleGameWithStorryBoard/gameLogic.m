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

//Verry quick solution for generating all possible words for a given set of letters
-(BOOL)binarySearchForItem:(NSString *)item
                      From:(NSInteger)start
                        To:(NSInteger)finish
                   inArray:(NSArray *)array
{
    
    NSInteger middle = ((finish - start) / 2) + start;
    NSString *middleItem = array[middle];
    NSComparisonResult compare = [item compare:middleItem];
    if (ABS(start - finish) < 2){
        if ([item isEqualToString:array[start]]){
            return YES;
        }else if ([item isEqualToString:array[finish]]){
            return YES;
        }
        else{
            return NO;
        }
    }
    if (compare == NSOrderedSame){
        return YES;
    }else if (compare == NSOrderedAscending){
        return [self binarySearchForItem:item From:start To:middle inArray:array];
    }else{
        return [self binarySearchForItem:item From:middle To:finish inArray:array];
    }
}

//This function uses binary search
//returns a range where all the words beggining with the letters in item can be found
//If no words begging with item are found it returns a range of (-1,-1)
-(NSRange)searchForStartingSequence:(NSString *)item
                       inDictionary:(NSArray *)array
                              start:(NSInteger)start
                             finish:(NSInteger)finish;
{
    NSInteger middle = ((finish - start) / 2) + start;
    NSString *middleItem = array[middle];
    if ([middleItem length] > [item length]){
        middleItem = [middleItem substringToIndex:([item length])];
    }
    NSComparisonResult compare = [item compare:middleItem];
    if (ABS(start - finish) < 2){
        if ([item isEqualToString:array[start]] || [item isEqualToString:array[start]]){
            return NSMakeRange(start, (finish - start));
        }
        else{
            return NSMakeRange(-1, -1); //returns -1 -1 if starting sequence does not exist in dictionary
        }
    }
    if (compare == NSOrderedSame){
        return NSMakeRange(start, (finish - start));
    }else if (compare == NSOrderedAscending){
        return [self searchForStartingSequence:item inDictionary:array start:start finish:middle];
    }else{
        return [self searchForStartingSequence:item inDictionary:array start:middle finish:finish];
    }
}


//Searches makes all permutaions from lettersToAdd
//Adds each letter from letters to add as the next letter in newWord and runs recursively on each combination
//remove the letter added to newWord from lettersToAdd for that path
//Function also checks the dictionary for each newWord to see if there are any words that start with newWord
//if not the recursive branch is pruned.
//If a word is found startinf with newWord the range is updated to contain the range of words in the dictionary
//containing all the words starting with newWord. This narrows down the section of the dictionary
//needed to search to determine if the word is in the dictionary.

-(NSString *)allPermutationsFromLetters:(NSMutableArray *)lettersToAdd
                              toNewWord:(NSMutableArray *)newWord
                         runningLongest:(NSString *)runningLongest
                    withDictionaryRange:(NSRange)range
                      englishDictionary:(NSArray *)dictionary
{

    NSRange newRange = range;
    if ([newWord count] > 0){
        NSRange newRange = [self searchForStartingSequence:[self convertArrayToString:newWord] inDictionary:dictionary start:range.location finish:(range.location + range.length)];
        if (newRange.length == -1){
            return @""; // returns empty string if the no words begin with the letters in newWord
        }else{
            NSString *wordAsString = [self convertArrayToString:newWord];
            if ([self binarySearchForItem:wordAsString From:newRange.location To:(newRange.location + newRange.length) inArray:dictionary]){
            //    NSLog(@"%@",wordAsString);
            }
        }
    }
    NSArray *distinctLetters = [self allDistinctFrom:lettersToAdd];
    for (NSInteger i = 0; i < [distinctLetters count]; i++){
        NSMutableArray *lettersToAddCopy = [lettersToAdd mutableCopy];
        NSMutableArray *newWordCopy = [newWord mutableCopy];
        NSString *letterToTransfer = distinctLetters[i];
        [lettersToAdd removeObjectAtIndex:[lettersToAdd indexOfObject:letterToTransfer]];
        [newWord addObject:letterToTransfer];
        [self allPermutationsFromLetters:lettersToAdd toNewWord:newWord runningLongest:runningLongest withDictionaryRange:newRange englishDictionary:dictionary];
        newWord = newWordCopy;
        lettersToAdd = lettersToAddCopy;
    }
    return runningLongest;
}

-(NSRange)startingSequenceIsInDictionary:(NSArray *)startingSequence
                                forRange:(NSRange)range
                         usingDictionary:(NSArray *)dictionary
{
    NSString *startingSequenceString = [self convertArrayToString:startingSequence];
    return [self searchForStartingSequence:startingSequenceString inDictionary:dictionary start:range.location finish:(range.location + range.length)];
}

//returns an array of all the distinct items in the input array
-(NSArray *)allDistinctFrom:(NSMutableArray *)arrayWithDuplicates
{
    NSMutableArray *distinctArray = [[NSMutableArray alloc]init];
    for (NSString *item in arrayWithDuplicates){
        if (![distinctArray containsObject:item]){
            [distinctArray addObject:item];
        }
    }
    return distinctArray;
}

//main function which the user would pass the letters to.
-(NSString *)makeLargestFormLetters:(NSString *)letters{
    NSMutableArray *lettersArray = [self convertWordToLetterArray:letters];
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSRange fullRange = NSMakeRange(0, ([appD.allWords count] - 1));
    NSString *runningLongest = @"";
    [self allPermutationsFromLetters:lettersArray toNewWord:[@[] mutableCopy] runningLongest:runningLongest withDictionaryRange:fullRange englishDictionary:appD.allWords];
    return runningLongest;
}


-(NSString *)makeLargestFormArray:(NSMutableArray *)lettersArray{
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSRange fullRange = NSMakeRange(0, ([appD.allWords count] - 1));
    NSString *runningLongest = @"";
    [self allPermutationsFromLetters:lettersArray toNewWord:[@[] mutableCopy] runningLongest:runningLongest withDictionaryRange:fullRange englishDictionary:appD.allWords];
    return runningLongest;
}












-(BOOL)wordIsInDictionary:(NSArray *)startingSequence
                    forRange:(NSRange)range
               dictionary:(NSMutableArray *)dictionary
{
    NSString *word = [self convertArrayToString:startingSequence];
    return [self binarySearchForItem:word From:range.location To:(range.location + range.length) inArray:dictionary];
}




-(NSMutableArray *)convertWordToLetterArray:(NSString *)word
{
    NSMutableArray *allLetters = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < [word length]; i++){
        [allLetters addObject:[NSString stringWithFormat:@"%c",[word characterAtIndex:i]]];
    }
    return allLetters;
}





-(NSString *)makeComputerMove
{
    for (NSInteger rangeLength = [self.lettersInPlay count] - 1; rangeLength > 0; rangeLength--){
        NSRange searchSection = NSMakeRange(0, rangeLength);
        NSMutableArray *wordFromArray = [[self.lettersInPlay subarrayWithRange:searchSection] mutableCopy];
        /*  NSString *word = [self makeLargestFormLetters:(NSString *)];
         if (word){
         return word;
         }*/
    }
    return nil;
}

-(NSString *)convertArrayToString:(NSArray *)letterArray
{
    NSMutableString *outputString = [[NSMutableString alloc]initWithString:@""];
    for (NSString *letter in letterArray){
        [outputString appendString:letter];
    }
    return outputString;
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
    [self.selectedLetters removeAllObjects];
    return score;
}

-(void)updateSore{
    self.score += [self scoreWord];
}




-(BOOL)isDictionaryWord:(NSString*) word {
    AppDelegate *appD = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self binarySearchForItem:word From:0 To:[appD.allWords count] inArray:appD.allWords];
}
@end
