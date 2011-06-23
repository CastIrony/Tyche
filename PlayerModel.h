
//  PlayerModel.h
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "Model.h"

@interface PlayerModel : Model 

+(PlayerModel*)playerModel;

@property (nonatomic, assign) int status; // context of status depends on the specific game controller

@property (nonatomic, retain)   NSMutableArray*      cards;
@property (nonatomic, retain)   NSMutableArray*      orderedCards;
@property (nonatomic, retain)   NSMutableDictionary* chips;
@property (nonatomic, assign)   int chipTotal;
@property (nonatomic, readonly) int betTotal;
@property (nonatomic, readonly) int numberOfCardsMarked;
@property (nonatomic, readonly) NSArray* cardKeys;
@property (nonatomic, readonly) NSArray* heldKeys;
@property (nonatomic, readonly) NSArray* heldCards;
@property (nonatomic, readonly) NSArray* drawnKeys;
@property (nonatomic, readonly) NSArray* drawnCards;

-(void)cancelBets;
-(void)allIn;

@end