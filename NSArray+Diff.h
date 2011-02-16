//
//  NSArray+Diff.h
//  JBCommon
//
//  Created by Joel Bernstein on 11/29/10.
//  Copyright 2010 Joel Bernstein. All rights reserved.

@interface JBDiffResult : NSObject

@property (nonatomic, retain) NSArray* oldArray;
@property (nonatomic, retain) NSArray* newArray;
@property (nonatomic, retain) NSArray* lcsArray;
@property (nonatomic, retain) NSArray* combinedArray;

@property (nonatomic, retain) NSArray* deletedObjects;
@property (nonatomic, retain) NSArray* insertedObjects;

// deletedIndexes and insertedIndexes are the indexes that must be deleted from the oldArray, 
// and then inserted to form the newArray. These are useful for tableview animation.

@property (nonatomic, retain) NSIndexSet* deletedIndexes;
@property (nonatomic, retain) NSIndexSet* insertedIndexes;

// combinedDeletedIndexes and combinedInsertedIndexes are indexes to the combinedArray,
// used to display which elements in combinedArray were inserted or deleted.

@property (nonatomic, retain) NSIndexSet* combinedDeletedIndexes;
@property (nonatomic, retain) NSIndexSet* combinedInsertedIndexes;

@end

@interface NSArray (Diff)

-(JBDiffResult*)diffWithArray:(NSArray*)newArray;

@end
