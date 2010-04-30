@interface SoundController : NSObject 
{
}

+(void)addSoundEffect:(NSString*)filename forKey:(NSString*)key;
+(void)playSoundEffectForKey:(NSString*)key;

@end
