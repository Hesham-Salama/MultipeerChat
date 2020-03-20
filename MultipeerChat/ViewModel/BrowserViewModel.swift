//
//  Browsing.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/18/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class BrowserViewModel: NSObject, ObservableObject {
    @Published var connectedPeers = [MCPeerID]()
    @Published var availablePeers = [MCPeerID]()
    @Published var didNotStartBrowsing = false
    var startErrorMessage = ""
    private let browser: MCNearbyServiceBrowser
    private let invitationTimeout: TimeInterval = 60.0
    
    private lazy var session: MCSession = {
        let newSession = MCSession(peer: browser.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        return newSession
    }()
    
    override init() {
        guard let peerID = UserPeer.shared.peerID else {
            fatalError("No PeerID detected!")
        }
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MultipeerConstants.serviceType)
        super.init()
        browser.delegate = self
    }
    
    func stopBrowsing() {
        browser.stopBrowsingForPeers()
    }
    
    func startBrowsing() {
        browser.startBrowsingForPeers()
    }
    
    func peerClicked(peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: invitationTimeout)
    }
}

extension BrowserViewModel: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found a new peer: \(peerID.displayName)")
        availablePeers.append(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        availablePeers = availablePeers.filter { $0 != peerID }
        connectedPeers = connectedPeers.filter { $0 != peerID }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        startErrorMessage = error.localizedDescription
        didNotStartBrowsing = true
    }
}
