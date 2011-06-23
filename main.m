//
//  main.m
//  Studly
//
//  Created by Joel Bernstein on 9/24/09.
//  Copyright Joel Bernstein 2009. All rights reserved.
//

int main(int argc, char* argv[]) 
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];

    @try
    {
        return UIApplicationMain(argc, argv, @"UIApplication", @"AppController");
    }
    @catch(NSException* exception)
    {
        LOG_NS(@"%@", exception);
    }
    @finally
    {
        [pool release];
    }
}