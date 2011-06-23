@interface JBDiffResult : NSObject

@property (nonatomic, retain) NSArray* oldArray;
@property (nonatomic, retain) NSArray* newArray;
@property (nonatomic, retain) NSArray* lcsArray;
@property (nonatomic, retain) NSArray* combinedArray;

// deletedIndexes and insertedIndexes are the indexes that must be deleted from the oldArray, 
// and then inserted to form the newArray. These are useful for tableview animation.

@property (nonatomic, retain) NSIndexSet* deletedIndexes;
@property (nonatomic, retain) NSIndexSet* insertedIndexes;

// combinedDeletedIndexes and combinedInsertedIndexes are indexes to the combinedArray,
// used to display which elements in combinedArray were inserted or deleted.

@property (nonatomic, retain) NSIndexSet* combinedDeletedIndexes;
@property (nonatomic, retain) NSIndexSet* combinedInsertedIndexes;

@end

@interface NSArray (JBCommon)

-(id)objectBefore:(id)object;
-(id)objectAfter:(id)object;

-(NSArray*)arrayByRemovingObjectsInArray:(NSArray*)array;
-(NSArray*)arrayByRemovingObjectsAtIndexes:(NSIndexSet*)indexes;
-(NSArray*)arrayByRemovingObjectAtIndex:(NSUInteger)index;

-(NSArray*)objectsAtIndexes:(NSUInteger[])indexes count:(NSUInteger)count;

-(NSArray*)choose:(NSUInteger)count;

-(JBDiffResult*)diffWithArray:(NSArray*)newArray;

@end
