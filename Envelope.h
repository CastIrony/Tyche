//
//  Envelope.h
//  Studly
//
//  Created by Joel Bernstein on 3/15/10.
//  Copyright 2010 Joel Bernstein. All rights reserved.
//

@class GameModel;

@interface Envelope : NSObject 

@property (nonatomic, copy)   NSString*  from;
@property (nonatomic, copy)   NSString*  status;
@property (nonatomic, retain) GameModel* game;

+(id)withStatusMessage:(NSString*)status andGame:(GameModel*)game from:(NSString*)from;

+(id)withData:(NSData*)data;
-(NSData*)toData;

+(id)withDictionary:(NSDictionary*)dictionary;
-(id)proxyForJson;

@end
