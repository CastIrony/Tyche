//
//  Envelope.m
//  Studly
//
//  Created by Joel Bernstein on 3/15/10.
//  Copyright 2010 Joel Bernstein. All rights reserved.
//

#import "GameModel.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

#import "Envelope.h"

@implementation Envelope

@synthesize from = _from;
@synthesize status = _status;
@synthesize game = _game;

+(id)withStatusMessage:(NSString*)status andGame:(GameModel*)game from:(NSString*)from
{
    Envelope* envelope = [[[Envelope alloc] init] autorelease];
    
    envelope.status = status;
    envelope.game = game;
    envelope.from = from;
    
    return envelope;
}

+(id)withData:(NSData*)data
{
    return [Envelope withDictionary:[[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease] JSONValue]];
}

-(NSData*)toData
{
    return [[self JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding];
}

+(id)withDictionary:(NSDictionary*)dictionary
{
    Envelope* envelope = [[[Envelope alloc] init] autorelease];
    
    envelope.game = [GameModel gameModel];
    
    [envelope.game loadFromDictionary:[dictionary objectForKey:@"game"]];
    
    return envelope;
}

-(id)proxyForJson
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:self.game forKey:@"game"];
    
    return dictionary;
}

@end
