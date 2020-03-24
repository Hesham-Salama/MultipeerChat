//
//  Browsing.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/18/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class BrowserViewModel: NSObject, ObservableObject {
    
    @Published var connectedPeers = [BrowsedPeer]()
    @Published var availablePeers = [BrowsedPeer]()
    @Published var didNotStartBrowsing = false
    @Published var couldntConnect = false
    var startErrorMessage = ""
    var couldntConnectMessage = ""
    private let browser: MCNearbyServiceBrowser
    private let invitationTimeout: TimeInterval = 60.0
    
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
        let newSession = SessionManager.shared.newSession
        newSession.delegate = self
        browser.invitePeer(peer, to: newSession, withContext: nil, timeout: invitationTimeout)
        setAvailablePeerStatus(peer, status: .connecting)
    }
    
    private func removeUnavailablePeer(peerID: MCPeerID) {
        availablePeers.removeAll {
            $0.peerID.hashValue == peerID.hashValue
        }
        connectedPeers.removeAll {
            $0.peerID.hashValue == peerID.hashValue
        }
    }
    
    private func moveToConnectedPeers(peerID: MCPeerID) {
        guard let index = (availablePeers.firstIndex {
            $0.peerID.hashValue == peerID.hashValue
        }) else {
            return
        }
        var peer = self.availablePeers.remove(at: index)
        peer.status = .connected
        self.connectedPeers.append(peer)
    }
    
    private func setAvailablePeerStatus(_ peerID: MCPeerID, status: PeerStatus) {
        guard let index = (availablePeers.firstIndex {
            $0.peerID.hashValue == peerID.hashValue
        }) else {
            return
        }
        var peer = self.availablePeers.remove(at: index)
        peer.status = status
        self.availablePeers.insert(peer, at: index)
    }
    
    private func showCouldntConnectError(failedToConnectPeer: MCPeerID) {
        couldntConnectMessage = "Couldn't connect to \(failedToConnectPeer.displayName)"
        couldntConnect = true
    }
}

extension BrowserViewModel: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found a new peer: \(peerID.displayName)")
        let peer = BrowsedPeer(peerID: peerID, status: .available)
        availablePeers.append(peer)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        removeUnavailablePeer(peerID: peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        startErrorMessage = error.localizedDescription
        didNotStartBrowsing = true
    }
}

extension BrowserViewModel: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            switch state {
            case .notConnected:
                print("Failed to connect to \(peerID.displayName)")
                self?.setAvailablePeerStatus(peerID, status: .available)
                self?.showCouldntConnectError(failedToConnectPeer: peerID)
            case .connecting:
                print("Connecting to \(peerID.displayName)")
            case .connected:
                print("Connected to \(peerID.displayName)")
                self?.moveToConnectedPeers(peerID: peerID)
            @unknown default:
                break
            }
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
