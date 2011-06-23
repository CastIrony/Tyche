
//  ChipModel.h
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "Model.h"

@interface ChipModel : Model 

+(ChipModel*)chipModel;

@property (nonatomic, copy)     NSString* key;
@property (nonatomic, assign)   int       chipCount;
@property (nonatomic, assign)   int       betCount;
@property (nonatomic, readonly) int       displayCount;

@end
