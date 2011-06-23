
//  AppModel.h
//  Studly
//
//  Created by Joel Bernstein on 2/7/11.
//  Copyright 2011 Joel Bernstein. All rights reserved.

#import "Model.h"

@class GameModel;

@interface AppModel : Model

+(AppModel*)appModel;

@property (nonatomic, retain) GameModel* gameModel;

-(void)save;
-(void)load;

@end
