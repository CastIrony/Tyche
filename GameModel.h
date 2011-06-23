
//  GameModel.h
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "Model.h"

@class RoundModel;

@interface GameModel : Model 

@property (nonatomic, copy)   NSString*            type;
@property (nonatomic, copy)   NSString*            dealerKey;
@property (nonatomic, retain) NSMutableArray*      playerKeys;
@property (nonatomic, retain) NSMutableDictionary* players;
@property (nonatomic, retain) NSMutableArray*      deck;
@property (nonatomic, retain) NSMutableArray*      discard;
@property (nonatomic, assign) int                  status; // context of status depends on the specific game controller
@property (nonatomic, retain) RoundModel*          roundModel;

+(GameModel*)gameModel;

-(NSMutableArray*)getCards:(int)count;

@end