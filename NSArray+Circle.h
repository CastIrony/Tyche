@interface NSArray (Circle)

-(id)objectBefore:(id)object;
-(id)objectAfter:(id)object;
-(NSArray*)commonObjectsWithArray:(NSArray*)array;

-(id)objectBefore:(id)object commonWithArray:(NSArray*)array;
-(id)objectAfter:(id)object commonWithArray:(NSArray*)array;

@end
