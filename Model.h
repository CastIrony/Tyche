
//  Model.h
//  Tyche
//
//  Created by Joel Bernstein on 4/1/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

@interface Model : NSObject

-(void)loadFromDictionary:(NSDictionary*)dictionary;
-(NSDictionary*)saveToDictionary;

@end
