#import "NSArray+JBCommon.h"

@implementation JBDiffResult

@synthesize oldArray;
@synthesize newArray;
@synthesize lcsArray;
@synthesize combinedArray;
@synthesize deletedIndexes;
@synthesize insertedIndexes;
@synthesize combinedDeletedIndexes;
@synthesize combinedInsertedIndexes;

-(NSString*)description
{
    return [NSString stringWithFormat:@"deleted:%@, added:%@", deletedIndexes, insertedIndexes];
}

@end

static int factorial(int n)
{
    int result = 1;
    
    for(int i = n; i > 1; i--)
    {
        result *= i;
    }
    
    return result;
}

static int binomial(int n, int k)
{
    return factorial(n) / (factorial(k) * factorial(n - k));   
}

@implementation NSArray (JBCommon)

-(id)objectBefore:(id)object
{
    int objectIndex = [self indexOfObject:object] - 1;
    
    if(objectIndex == -1)
    {
        return [self lastObject];
    }
    else
    {
        return [self objectAtIndex:(objectIndex)];
    }
}

-(id)objectAfter:(id)object
{
    int objectIndex = [self indexOfObject:object] + 1;
    
    if(objectIndex == (int)self.count)
    {
        return [self objectAtIndex:0];
    }
    else
    {
        return [self objectAtIndex:(objectIndex)];
    }    
}

-(NSArray*)arrayByRemovingObjectsInArray:(NSArray*)array
{
    NSMutableArray* newArray = [[self mutableCopy] autorelease];
    
    [newArray removeObjectsInArray:array];
    
    return newArray;
}

-(NSArray*)arrayByRemovingObjectsAtIndexes:(NSIndexSet*)indexes
{
    NSMutableArray* newArray = [[self mutableCopy] autorelease];
    
    [newArray removeObjectsAtIndexes:indexes];
    
    return newArray;
}

-(NSArray*)arrayByRemovingObjectAtIndex:(NSUInteger)index
{
    NSMutableArray* newArray = [[self mutableCopy] autorelease];
    
    [newArray removeObjectAtIndex:index];
    
    return newArray;
}

-(NSArray*)objectsAtIndexes:(NSUInteger[])indexes count:(NSUInteger)count
{
    NSMutableIndexSet* indexSet = [NSMutableIndexSet indexSet];
    
    for(int i = 0; i < count; i++)
    {
        [indexSet addIndex:indexes[i]];
    }
    
    return [self objectsAtIndexes:indexSet];
}

//Algorithm from http://compprog.wordpress.com/2007/10/17/generating-combinations-1/
// TODO - implement the permutation algorithm from http://compprog.wordpress.com/2007/10/08/generating-permutations-2/

-(NSArray*)choose:(NSUInteger)count
{
    NSMutableArray* combinations = [NSMutableArray array];
    
    NSUInteger combinationIndexes[count];
    
    for(NSUInteger i = 0; i < count; i++)
    {
        combinationIndexes[i] = i;
    }
    
    for(NSUInteger i = 0; i < binomial(self.count, count); i++)
    {
        [combinations addObject:[self objectsAtIndexes:combinationIndexes count:count]];
        
        NSUInteger j = count - 1;
        
        combinationIndexes[j]++;
        
        while(combinationIndexes[j] >= self.count - count + 1 + j)
        {
            j--;
            
            combinationIndexes[j]++;
        }
        
        for(j = j + 1; j < count; j++)
        {
            combinationIndexes[j] = combinationIndexes[j - 1] + 1;
        }
    }
    
    return combinations;
}

// Bottom-Up Iterative LCS algorithm from http://www.ics.uci.edu/~eppstein/161/960229.html

-(JBDiffResult*)diffWithArray:(NSArray*)newArray;
{
    int lengthArray[self.count + 1][newArray.count + 1];    
    
    for(int selfIndex = self.count; selfIndex >= 0; selfIndex--)
	{    
        for(int newIndex = newArray.count; newIndex >= 0; newIndex--)
	    {
            if(selfIndex == self.count || newIndex == newArray.count)
            {
                lengthArray[selfIndex][newIndex] = 0;
            }
            else if([[self objectAtIndex:selfIndex] isEqual:[newArray objectAtIndex:newIndex]]) 
            {
                lengthArray[selfIndex][newIndex] = 1 + lengthArray[selfIndex + 1][newIndex + 1];
            }
            else
            {
                lengthArray[selfIndex][newIndex] = MAX(lengthArray[selfIndex + 1][newIndex], lengthArray[selfIndex][newIndex + 1]);
            }
	    }
    }
    
    NSMutableArray*    lcsArray                = [NSMutableArray array];
    NSMutableArray*    combinedArray           = [NSMutableArray array];
    NSMutableIndexSet* deletedIndexes          = [NSMutableIndexSet indexSet];
    NSMutableIndexSet* insertedIndexes         = [NSMutableIndexSet indexSet]; 
    NSMutableIndexSet* combinedDeletedIndexes  = [NSMutableIndexSet indexSet];
    NSMutableIndexSet* combinedInsertedIndexes = [NSMutableIndexSet indexSet]; 
    
    int selfIndex = 0;
    int newIndex = 0;
    int combinedIndex = 0;
    
    while(selfIndex < self.count && newIndex < newArray.count)
    {
        if([[self objectAtIndex:selfIndex] isEqual:[newArray objectAtIndex:newIndex]])
        {
            [lcsArray      addObject:[self objectAtIndex:selfIndex]];
            [combinedArray addObject:[self objectAtIndex:selfIndex]];
            
            selfIndex++; 
            newIndex++;
            combinedIndex++;
        }
        else if(lengthArray[selfIndex + 1][newIndex] >= lengthArray[selfIndex][newIndex + 1])
        {
            [combinedArray          addObject:[self objectAtIndex:selfIndex]];
            [deletedIndexes         addIndex:selfIndex];
            [combinedDeletedIndexes addIndex:combinedIndex];
            
            selfIndex++;
            combinedIndex++;
        }
        else
        {
            [combinedArray           addObject:[newArray objectAtIndex:newIndex]];
            [insertedIndexes         addIndex:newIndex];
            [combinedInsertedIndexes addIndex:combinedIndex];
            
            newIndex++;
            combinedIndex++;
        }
    }
    
    while(selfIndex < self.count) 
    {
        [combinedArray          addObject:[self objectAtIndex:selfIndex]];
        [deletedIndexes         addIndex:selfIndex];
        [combinedDeletedIndexes addIndex:combinedIndex];
        
        selfIndex++;
        combinedIndex++;
    }
    
    while(newIndex < newArray.count) 
    {
        [combinedArray           addObject:[newArray objectAtIndex:newIndex]];
        [insertedIndexes         addIndex:newIndex];
        [combinedInsertedIndexes addIndex:combinedIndex];
        
        newIndex++;
        combinedIndex++;
    }
    
    JBDiffResult* result = [[[JBDiffResult alloc] init] autorelease];
    
    result.oldArray                = [self copy];
    result.newArray                = [newArray copy];
    result.lcsArray                = lcsArray;               
    result.combinedArray           = combinedArray;          
    result.deletedIndexes          = deletedIndexes;         
    result.insertedIndexes         = insertedIndexes;        
    result.combinedDeletedIndexes  = combinedDeletedIndexes; 
    result.combinedInsertedIndexes = combinedInsertedIndexes;
    
    return result;
}

@end