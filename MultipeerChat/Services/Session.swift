//
//  Session.swift
//  MultipeerChat
//
//  Created by Hesham on 3/18/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class Session: NSObject {
    let mcSession: MCSession
    
    init(peerID: MCPeerID, serviceType: String) {
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        mcSession.delegate = self
    }
}

extension Session: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Peer ID \(peerID.displayName) disconnected")
        case .connected:
            print("Peer ID \(peerID.displayName) connected")
        case .connecting:
            print("Peer ID \(peerID.displayName) is connecting")
        @unknown default:
            print("Peer ID \(peerID.displayName) - unknown")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Recieved data from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
