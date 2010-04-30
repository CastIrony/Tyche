#import "NSMutableArray+Deck.h"
#import "SoundController.h"

static NSMutableDictionary* soundEffects;

@implementation SoundController

+(void)addSoundEffect:(NSString*)filename forKey:(NSString*)key
{
    if(!soundEffects) { soundEffects = [[NSMutableDictionary alloc] init]; }
    
    if(![soundEffects objectForKey:key]) { [soundEffects setObject:[[[NSMutableArray alloc] init] autorelease] forKey:key]; }
    
    SystemSoundID soundID;
    
    AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:filename], &soundID);
            
    [[soundEffects objectForKey:key] addObject:[NSNumber numberWithInt:(int)soundID]];
}

+(void)playSoundEffectForKey:(NSString*)key
{
    NSMutableArray* sounds = [soundEffects objectForKey:key];
    
    NSNumber* sound = [sounds randomObject];
    
    if(sound)
    {
        AudioServicesPlaySystemSound((SystemSoundID)[sound intValue]);
    }
}

@end
