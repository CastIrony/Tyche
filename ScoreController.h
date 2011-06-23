
//  HandModel.h
//  Studly
//
//  Created by Joel Bernstein on 3/1/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

typedef enum 
{
    HandRankRoyalFlush    = 9,
    HandRankStraightFlush = 8,
    HandRankFourOfAKind   = 7,
    HandRankFullHouse     = 6,
    HandRankFlush         = 5,
    HandRankStraight      = 4,
    HandRankThreeOfAKind  = 3,
    HandRankTwoPair       = 2,
    HandRankPair          = 1,
    HandRankHighCard      = 0
} 
HandRank;

@interface ScoreController : NSObject <NSCopying>

@property (nonatomic, readonly, assign) HandRank rank;
@property (nonatomic, readonly, copy)   NSArray* scoredCards;
@property (nonatomic, readonly, copy)   NSArray* otherCards;

+(ScoreController*)handWithRank:(HandRank)rank scoredCards:(NSArray*)scoredCards otherCards:(NSArray*)otherCards;
+(ScoreController*)scoreCards:(NSArray*)cards;

-(NSComparisonResult)compare:(ScoreController*)otherHand;

@end