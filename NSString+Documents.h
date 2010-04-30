//
//  NSString+DocumentWrite.h
//  Tyche
//
//  Created by Joel Bernstein on 9/15/09.
//  Copyright 2009 Joel Bernstein. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Documents)

-(BOOL)writeToDocument:(NSString*)fileName;
+(NSString*)stringWithContentsOfDocument:(NSString*)fileName;
-(BOOL)documentExists;
-(void)deleteDocument;

@end
