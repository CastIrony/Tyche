#import "Envelope.h"
#import "GameController.h"

#import "GameNetworkControllerGK.h"

@implementation GameNetworkControllerGK

//@synthesize session = _session;
//@synthesize gameController = _gameController;

-(void)session:(GKSession*)session connectionWithPeerFailed:(NSString*)peerID withError:(NSError*)error 
{    
    // Should never happen for a server
}

-(void)session:(GKSession*)session didFailWithError:(NSError*)error 
{ 
    // Kill session and disconnect
}

-(void)session:(GKSession*)session didReceiveConnectionRequestFromPeer:(NSString*)peerID 
{
    // Accept connection request; we can always cancel it later
    
    [session acceptConnectionFromPeer:peerID error:nil];
}

-(void)session:(GKSession*)session peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)state 
{     
    if(state == GKPeerStateAvailable)
    {
        // Who cares?
    }
    
    if(state == GKPeerStateUnavailable)
    {
        // Who cares?        
    }
    
    if(state == GKPeerStateConnected)
    {
       // Add peer to list of connected clients
    }
    
    if(state == GKPeerStateDisconnected)
    {
        // Remove peer from list of connected clients
    }
    
    if(state == GKPeerStateConnecting)
    {
        // Who cares?        
    }
}

//-(void)sendStatusReportMessageToPeer:(NSString*)peerId
//{
//    NSArray* peers = [NSArray arrayWithObject:peerId];
//    
//    NSData* data = [[Envelope withMessageType:MessageTypeStatusReport andGame:self.gameController.game] toData];
//    
//    [self.session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:nil];
//}

-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context
{
    //Envelope* envelope = [Envelope withData:data];
    
        // replace game model with the one in envelope.game
        
        // check if it's my turn and act accordingly        

        // otherwise wait until it is
    
}

@end
