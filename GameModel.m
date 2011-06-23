//
//  GameModel.m
//  Studly
//
//  Created by Joel Bernstein on 9/16/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "PlayerModel.h"
#import "CardModel.h"
#import "NSMutableArray+Deck.h"

#import "GameModel.h"

@implementation GameModel

+(GameModel*)gameModel
{
    return [[[GameModel alloc] init] autorelease];
}

@synthesize type       = _type;
@synthesize dealerKey  = _dealerKey;
@synthesize playerKeys = _playerKeys;
@synthesize players    = _players;
@synthesize deck       = _deck;
@synthesize discard    = _discard;
@synthesize status     = _status;
@synthesize roundModel = _roundModel;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.playerKeys = [NSMutableArray      array];
        self.players    = [NSMutableDictionary dictionary];
        self.deck       = [NSMutableArray      array];
        self.discard    = [NSMutableArray      array];
    }
    
    return self;
}

-(void)loadFromDictionary:(NSDictionary*)dictionary
{        
    self.playerKeys = [dictionary objectForKey:@"playerKeys"];    
    
    self.status = [[dictionary objectForKey:@"status"] intValue];
    
    NSDictionary* players = [dictionary objectForKey:@"players"];    
    
    for(NSString* key in players) 
    { 
        PlayerModel* playerModel = [PlayerModel playerModel];
        
        [playerModel loadFromDictionary:[players objectForKey:key]];
        
        [self.players setObject:playerModel forKey:key];
    }
    
    for(NSDictionary* card in [dictionary objectForKey:@"deck"])
    {
        CardModel* cardModel = [CardModel cardModel];
        
        [cardModel loadFromDictionary:card];

        [self.deck addObject:card];
    }
    
    for(NSDictionary* card in [dictionary objectForKey:@"discard"])
    {
        CardModel* cardModel = [CardModel cardModel];
        
        [cardModel loadFromDictionary:card];
        
        [self.discard addObject:card];
    }
}

-(NSDictionary*)saveToDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.playerKeys                       forKey:@"playerKeys"];
    [dictionary setObject:self.players                         forKey:@"players"];
    [dictionary setObject:self.deck                            forKey:@"deck"];
    [dictionary setObject:self.discard                         forKey:@"discard"];
    [dictionary setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];    
    
    return dictionary;
}

-(NSMutableArray*)getCards:(int)count
{
    NSMutableArray* cards = [NSMutableArray array];
    
    for(int i = 0; i < count; i++) 
    {         
        if(self.deck.count == 0) 
        { 
            [self.deck addObjectsFromArray:self.discard];
            [self.deck shuffle];
            
            [self.discard removeAllObjects];
        }
        
        [cards addObject:[self.deck popObject]]; 
    }
    
    return cards;
}

@end
