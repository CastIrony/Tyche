@interface PotatoModel : NSObject 
{
    NSMutableArray*      _peerIds;
    NSMutableDictionary* _players;
    NSMutableArray*      _deck;
    NSMutableArray*      _discard;
}

-(id)proxyForJson;

+(id)withDictionary:(NSDictionary*)dictionary;

@end
