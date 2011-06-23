#import "GameNetworkController.h"

@implementation GameNetworkController

@synthesize gameController = _gameController;
@synthesize session = _session;
@synthesize serverPeerId = _serverPeerId;

-(void)session:(GKSession*)session connectionWithPeerFailed:(NSString*)peerID withError:(NSError*)error {}
-(void)session:(GKSession*)session didFailWithError:(NSError*)error {}
-(void)session:(GKSession*)session didReceiveConnectionRequestFromPeer:(NSString*)peerID {}
-(void)session:(GKSession*)session peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)state {}

-(void)sendStatusMessage:(NSString*)status {}

-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context {}

@end
