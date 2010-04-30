//
//  GameModel.m
//  Tyche
//
//  Created by Joel Bernstein on 9/16/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "PlayerModel.h"
#import "NSMutableArray+Deck.h"

#import "GameModel.h"

@implementation GameModel

@synthesize playerIds = _playerIds;
@synthesize players   = _players;
@synthesize deck      = _deck;
@synthesize discard   = _discard;
@synthesize status    = _status;

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.playerIds = [[[NSMutableArray      alloc] init] autorelease];
        self.players   = [[[NSMutableDictionary alloc] init] autorelease];
        self.deck      = [[[NSMutableArray      alloc] init] autorelease];
        self.discard   = [[[NSMutableArray      alloc] init] autorelease];
    }
    
    return self;
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    if(!dictionary) { return nil; }
    
    GameModel* game = [[[GameModel alloc] init] autorelease];
    
    game.playerIds = [dictionary objectForKey:@"playerIds"];    
    
    game.status = (GameStatus)[[dictionary objectForKey:@"status"] intValue];
    
    NSDictionary* players = [dictionary objectForKey:@"players"];    
    
    for(NSString* key in players) 
    { 
        [game.players setObject:[PlayerModel withDictionary:[players objectForKey:key]] forKey:key];
    }
    
    for(NSDictionary* card in [dictionary objectForKey:@"deck"])
    {
        [game.deck addObject:[CardModel withDictionary:card]];
    }
    
    for(NSDictionary* card in [dictionary objectForKey:@"discard"])
    {
        [game.discard addObject:[CardModel withDictionary:card]];
    }
    
    return game;
}

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [[[NSMutableDictionary alloc] init] autorelease];
    
    [dictionary setObject:self.playerIds                       forKey:@"playerIds"];
    [dictionary setObject:self.players                         forKey:@"players"];
    [dictionary setObject:self.deck                            forKey:@"deck"];
    [dictionary setObject:self.discard                         forKey:@"discard"];
    [dictionary setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];    
    
    return dictionary;
}

-(NSMutableArray*)getCards:(int)count
{
    NSMutableArray* cards = [[[NSMutableArray alloc] init] autorelease];
    
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
