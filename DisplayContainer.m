#import "DisplayContainer.h"

@implementation DisplayContainer

@synthesize keys;
@synthesize objects;

+(DisplayContainer*)container 
{
    return [[[DisplayContainer alloc] init] autorelease];
}

+(DisplayContainer*)containerWithKeys:(NSArray*)keys objectDictionary:(NSDictionary*)objects 
{
    DisplayContainer* container = [[[DisplayContainer alloc] init] autorelease];
    
    container.keys = keys;
    container.objects = objects;
    
    return container;
}

-(DisplayContainer*)insertObject:(id)object asFirstWithKey:(id)key 
{
    if([self.keys containsObject:key])
    {
        
    }
    else 
    {
        [self.objects setValue:object forKey:key];
        [self.keys ]
    }

    return self; 
}

-(DisplayContainer*)insertObject:(id)object asLastWithKey:(id)key 
{
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key atIndex:(int)index 
{
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key beforeKey:(id)before 
{
    return self; 
}

-(DisplayContainer*)insertObject:(id)object withKey:(id)key afterKey:(id)after 
{
    return self; 
}


-(DisplayContainer*)moveKeyToFirst:(id)key 
{
    return self; 
}

-(DisplayContainer*)moveKeyToLast:(id)key 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key toIndex:(int)index 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key beforeKey:(id)before 
{
    return self; 
}

-(DisplayContainer*)moveKey:(id)key afterKey:(id)after 
{
    return self; 
}


-(DisplayContainer*)pruneObjectsForKey:(id)key toFormat:(NSString*)format 
{
    return self; 
}


-(NSArray*)objectsForKey:(id)key 
{
    return nil; 
}

-(id)topObjectForKey:(id)key 
{
    return nil; 
}

-(NSEnumerator*)keyEnumerator 
{
    return nil; 
}

-(NSEnumerator*)objectEnumerator 
{
    return nil; 
}

-(NSEnumerator*)topObjectEnumerator 
{
    return nil; 
}


-(NSEnumerator*)reverseKeyEnumerator 
{
    return nil; 
}

-(NSEnumerator*)reverseObjectEnumerator 
{
    return nil; 
}

-(NSEnumerator*)reverseTopObjectEnumerator 
{
    return nil; 
}

@end