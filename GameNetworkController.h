@class GameController;

@interface GameNetworkController : NSObject <GKSessionDelegate>

@property (nonatomic, assign) GameController* gameController;
@property (nonatomic, retain) GKSession*      session;
@property (nonatomic, copy)   NSString*       serverPeerId;

-(void)session:(GKSession*)session connectionWithPeerFailed:(NSString*)peerID withError:(NSError*)error;
-(void)session:(GKSession*)session didFailWithError:(NSError*)error;
-(void)session:(GKSession*)session didReceiveConnectionRequestFromPeer:(NSString*)peerID;
-(void)session:(GKSession*)session peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)state;

-(void)sendStatusMessage:(NSString*)status;

-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context;

@end
