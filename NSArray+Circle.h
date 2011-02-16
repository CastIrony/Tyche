@interface NSArray (Circle)

-(id)objectBefore:(id)object;
-(id)objectAfter:(id)object;

-(id)objectBefore:(id)object commonWithArray:(NSArray*)array;
-(id)objectAfter:(id)object commonWithArray:(NSArray*)array;

-(NSArray*)commonObjectsWithArray:(NSArray*)array;
-(NSArray*)arrayByRemovingObjectsInArray:(NSArray*)array;
-(NSArray*)arrayByRemovingIndexes:(NSIndexSet*)indexes;
-(NSArray*)map:(id(^)(id obj))block;

@end
