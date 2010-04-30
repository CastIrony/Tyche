#import "Envelope.h"
#import "GameControllerMP.h"

#import "SessionControllerClient.h"

@implementation SessionControllerClient

//@synthesize session = _session;
//@synthesize gameController = _gameController;

-(void)session:(GKSession*)session connectionWithPeerFailed:(NSString*)peerID withError:(NSError*)error 
{    
    // Recover from connection failure
}

-(void)session:(GKSession*)session didFailWithError:(NSError*)error 
{ 
    // Kill session and disconnect
}

-(void)session:(GKSession*)session didReceiveConnectionRequestFromPeer:(NSString*)peerID 
{
    // Should never happen for a client session
}

// [session connectToPeer:peerID withTimeout:60];

-(void)session:(GKSession*)session peer:(NSString*)peerID didChangeState:(GKPeerConnectionState)state 
{ 
    if(state == GKPeerStateAvailable)
    {
        // Add server to the available server list
    }
    
    if(state == GKPeerStateUnavailable)
    {
        // Remove server to the available server list
    }
    
    if(state == GKPeerStateDisconnected)
    {
        // If it's the server disconnecting, show the 'host disconnected' message, otherwise don't do anything
    }
    
    if(state == GKPeerStateConnected)
    {
        // If it's the server reconnecting, hide the 'host disconnected' message, otherwise don't do anything
    }
    
    if(state == GKPeerStateConnecting)
    {
        // Who cares?
    }
}

//-(void)sendTurnCompletedMessage
//{
//    NSArray* peers = [NSArray arrayWithObject:self.gameController.serverPeerId];
//    
//    NSData* data = [[Envelope withMessageType:MessageTypeTurnCompleted andGame:self.gameController.game] toData];
//    
//    [self.session sendData:data toPeers:peers withDataMode:GKSendDataReliable error:nil];
//}

-(void)receiveData:(NSData*)data fromPeer:(NSString*)peer inSession:(GKSession*)session context:(void*)context
{
    //Envelope* envelope = [Envelope withData:data];
    
        // if the 'connecting to host' message is visible, hide it
        
        // replace game model with the one in envelope.game
        
        // check if it's my turn and act accordingly
        
        // otherwise wait until it is
}

@end
