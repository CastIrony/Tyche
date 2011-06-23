
//  CardModel.h
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "Model.h"

@interface CardModel : Model;

+(CardModel*)cardModel;

@property (nonatomic, readonly) NSString* key;
@property (nonatomic, assign)   int       suit;
@property (nonatomic, assign)   int       numeral;
@property (nonatomic, readonly) int       numeralHigh;
@property (nonatomic, readonly) int       numeralLow;
@property (nonatomic, assign)   BOOL      isHeld;

-(NSComparisonResult)numeralCompareHigh:(CardModel*)otherCard;
-(NSComparisonResult)numeralCompareLow:(CardModel*)otherCard;

@end