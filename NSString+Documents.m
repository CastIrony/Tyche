//
//  NSString+DocumentWrite.m
//  Tyche
//
//  Created by Joel Bernstein on 9/15/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import "NSString+Documents.h"


@implementation NSString (Documents)

-(BOOL)writeToDocument:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = [paths objectAtIndex:0];
    
    NSString* filePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return [self writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
}

+(NSString*)stringWithContentsOfDocument:(NSString*)fileName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = [paths objectAtIndex:0];
    
    NSString* filePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
}

-(BOOL)documentExists
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = [paths objectAtIndex:0];
    
    NSString* filePath = [documentPath stringByAppendingPathComponent:self];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

-(void)deleteDocument
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentPath = [paths objectAtIndex:0];
    
    NSString* filePath = [documentPath stringByAppendingPathComponent:self];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
