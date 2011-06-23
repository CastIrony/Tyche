//
//  AppModel.m
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.
//

#import "NSString+Documents.h"
#import "JSON.h"

#import "AppModel.h"

@implementation AppModel

+(AppModel*)appModel
{
    return [[[AppModel alloc] init] autorelease];
}

@synthesize gameModel = _gameModel;

-(void)loadFromDictionary:(NSDictionary*)dictionary
{
    
}

-(NSDictionary*)saveToDictionary
{
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    
    return dictionary;
}

-(void)save
{    
    [[[self proxyForJson] JSONRepresentation] writeToDocument:@"studly.json"];
}

-(void)load
{    
    [self loadFromDictionary:[[NSString stringWithContentsOfDocument:@"studly.json"] JSONValue]];
}

@end
