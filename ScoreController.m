//
//  HandModel.m
//  Studly
//
//  Created by Joel Bernstein on 3/1/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "MC3DVector.h"
#import "CardModel.h"
#import "NSArray+JBCommon.h"
#import "ScoreController.h"

@interface ScoreController ()

@property (nonatomic, assign) HandRank rank;
@property (nonatomic, copy)   NSArray* scoredCards;
@property (nonatomic, copy)   NSArray* otherCards;

@end

@implementation ScoreController

@synthesize rank = _rank;
@synthesize scoredCards = _scoredCards;
@synthesize otherCards = _otherCards;

+(ScoreController*)hand
{
    return [[[ScoreController alloc] init] autorelease];
}

+(ScoreController*)handWithRank:(HandRank)rank scoredCards:(NSArray*)scoredCards otherCards:(NSArray*)otherCards
{
    ScoreController* hand = [ScoreController hand];
    
    hand.rank        = rank;
    hand.scoredCards = scoredCards;
    hand.otherCards  = otherCards;
    
    return hand;
}

+(ScoreController*)scoreCards:(NSArray*)cards high:(BOOL)high
{
    NSArray* sortedHand = [[[cards sortedArrayUsingSelector:high ? @selector(numeralCompareHigh:) : @selector(numeralCompareLow:)] reverseObjectEnumerator] allObjects];
    
    ScoreController* highestRank = [ScoreController hand];
    
    for(NSArray* combination in [sortedHand choose:5])
    {
        NSMutableArray* quadCards   = [NSMutableArray array];
        NSMutableArray* tripleCards = [NSMutableArray array];
        NSMutableArray* pairCards   = [NSMutableArray array];
        NSMutableArray* singleCards = [NSMutableArray array];
        
        CardModel* card1 = [combination objectAtIndex:0];
        CardModel* card2 = [combination objectAtIndex:1];
        CardModel* card3 = [combination objectAtIndex:2];
        CardModel* card4 = [combination objectAtIndex:3];
        CardModel* card5 = [combination objectAtIndex:4];
        
        [singleCards addObject:card5];
        [singleCards addObject:card4];
        [singleCards addObject:card3];
        [singleCards addObject:card2];
        [singleCards addObject:card1];
        
        if(card1.numeral == card2.numeral) { [pairCards addObject:card2]; [pairCards addObject:card1]; }
        if(card2.numeral == card3.numeral) { [pairCards addObject:card3]; [pairCards addObject:card2]; }
        if(card3.numeral == card4.numeral) { [pairCards addObject:card4]; [pairCards addObject:card3]; }
        if(card4.numeral == card5.numeral) { [pairCards addObject:card5]; [pairCards addObject:card4]; }
        
        if(card1.numeral == card3.numeral) { [tripleCards addObject:card3]; [tripleCards addObject:card2]; [tripleCards addObject:card1]; }
        if(card2.numeral == card4.numeral) { [tripleCards addObject:card4]; [tripleCards addObject:card3]; [tripleCards addObject:card2]; }
        if(card3.numeral == card5.numeral) { [tripleCards addObject:card5]; [tripleCards addObject:card4]; [tripleCards addObject:card3]; }
        
        if(card1.numeral == card4.numeral) { [quadCards addObject:card4]; [quadCards addObject:card3]; [quadCards addObject:card2]; [quadCards addObject:card1]; }
        if(card2.numeral == card5.numeral) { [quadCards addObject:card5]; [quadCards addObject:card4]; [quadCards addObject:card3]; [quadCards addObject:card2]; }
        
        [tripleCards removeObjectsInArray:quadCards];
        [pairCards   removeObjectsInArray:quadCards];
        [pairCards   removeObjectsInArray:tripleCards];
        [singleCards removeObjectsInArray:quadCards];
        [singleCards removeObjectsInArray:tripleCards];
        [singleCards removeObjectsInArray:pairCards];
        
        int pairs   = pairCards.count   / 2;
        int triples = tripleCards.count / 3;
        int quads   = quadCards.count   / 4;
        
        BOOL isFlush = card1.suit == card2.suit && card2.suit == card3.suit && card3.suit == card4.suit && card4.suit == card5.suit;
        
        BOOL isStraight = pairs == 0 && (high ? card5.numeralHigh : card5.numeralLow) == (high ? card1.numeralHigh : card1.numeralLow) + 4;
        
        ScoreController* handRank = [ScoreController hand];
        
        handRank.otherCards = singleCards;
        
        if(isFlush && isStraight && card5.numeralHigh == 14)
        {   
            handRank.rank = HandRankRoyalFlush;
            handRank.scoredCards = combination;
        }
        else if(isFlush && isStraight)                     
        { 
            handRank.rank = HandRankStraightFlush;
            handRank.scoredCards = combination;
        }
        else if(quads == 1)
        { 
            handRank.rank = HandRankFourOfAKind;
            handRank.scoredCards = quadCards;
        }
        else if(triples == 1 && pairs == 1)  
        { 
            handRank.rank = HandRankFullHouse;
            handRank.scoredCards = combination;
        }
        else if(isFlush)  
        { 
            handRank.rank = HandRankFlush;
            handRank.scoredCards = combination;
        }
        else if(isStraight)  
        { 
            handRank.rank = HandRankStraight;
            handRank.scoredCards = combination;
        }
        else if(triples == 1)  
        { 
            handRank.rank = HandRankThreeOfAKind;
            handRank.scoredCards = tripleCards;
        }
        else if(pairs == 2)  
        {
            handRank.rank = HandRankTwoPair;
            handRank.scoredCards = pairCards;
        }
        else if(pairs == 1)  
        { 
            handRank.rank = HandRankPair;
            handRank.scoredCards = pairCards;
        }
        else
        { 
            handRank.rank = HandRankHighCard;
            handRank.scoredCards = [combination objectsAtIndexes:[NSIndexSet indexSetWithIndex:0]];
            handRank.otherCards = [combination objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 4)]];
        }
        
        highestRank = [handRank compare:highestRank] == NSOrderedAscending ? highestRank : handRank;
    }
    
    return highestRank;
}

+(ScoreController*)scoreCards:(NSArray*)cards
{
    ScoreController* scoreHigh = [ScoreController scoreCards:cards high:YES];
    ScoreController* scoreLow  = [ScoreController scoreCards:cards high:NO];
    
    return [scoreLow compare:scoreHigh] == NSOrderedAscending ? scoreHigh : scoreLow;
}

-(NSComparisonResult)compare:(ScoreController*)otherHand
{
    if(!otherHand) { return NSOrderedDescending; }
    
    if(self.rank < otherHand.rank) { return NSOrderedAscending; }
    if(self.rank > otherHand.rank) { return NSOrderedDescending; }
    
    for(NSUInteger i = 0; i < MIN(self.scoredCards.count, otherHand.scoredCards.count); i++)
    {
        CardModel* selfCard  = [self.scoredCards      objectAtIndex:i];
        CardModel* otherCard = [otherHand.scoredCards objectAtIndex:i];
        
        NSComparisonResult result = [selfCard numeralCompareHigh:otherCard];
        
        if(result != NSOrderedSame) return result;
    }
    
    for(NSUInteger i = 0; i < MIN(self.otherCards.count, otherHand.otherCards.count); i++)
    {
        CardModel* selfCard  = [self.otherCards      objectAtIndex:i];
        CardModel* otherCard = [otherHand.otherCards objectAtIndex:i];
        
        NSComparisonResult result = [selfCard numeralCompareHigh:otherCard];
        
        if(result != NSOrderedSame) return result;
    }
    
    return NSOrderedSame;
}

-(id)copyWithZone:(NSZone*)zone
{
    return self;
}

@end