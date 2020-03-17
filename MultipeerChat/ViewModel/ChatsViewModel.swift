//
//  ChatsViewModel.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/14/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity

class ChatsViewModel: NSObject, ObservableObject {
    @Published var peers = [MultipeerUser]()
    let serviceType = "h-mpeerchat"
    private let mcSession: MCSession
    
    override init() {
        guard let peerID = UserPeer.shared.peerID else {
            fatalError("User must have been logged in!")
        }
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        super.init()
    }
}

extension ChatsViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            print("Peer ID \(peerID.displayName) disconnected")
        case .connected:
            print("Peer ID \(peerID.displayName) connected")
        case .connecting:
            break
        @unknown default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
