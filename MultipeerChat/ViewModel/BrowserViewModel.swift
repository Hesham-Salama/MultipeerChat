//
//  Browsing.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/18/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class BrowserViewModel: NSObject, ObservableObject {
    
    @Published var browsedPeers = [BrowsedPeer]()
    @Published var didNotStartBrowsing = false
    @Published var couldntConnect = false
    var startErrorMessage = ""
    var couldntConnectMessage = ""
    private let browser: MCNearbyServiceBrowser
    private let invitationTimeout: TimeInterval = 60.0
    
    private var newSession: MCSession {
        let session = SessionManager.shared.newSession
        session.delegate = self
        return session
    }
    
    var availableAndConnectingPeers : [BrowsedPeer] {
        return browsedPeers.filter { $0.currentStatus == .available || $0.currentStatus == .connecting }
    }
    
    var connectedPeers : [BrowsedPeer] {
        return browsedPeers.filter { $0.currentStatus == .connected }
    }
    
    override init() {
        guard let peerID = UserMP.shared.peerID else {
            fatalError("No PeerID detected!")
        }
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: MultipeerConstants.serviceType)
        super.init()
    }
    
    func stopBrowsing() {
        print("Browsing has stopped")
        browser.delegate = nil
        browser.stopBrowsingForPeers()
    }
    
    func startBrowsing() {
        print("Browsing has started")
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    
    func peerClicked(browsedPeer: BrowsedPeer) {
        if isPeerAvailableToConnect(peerID: browsedPeer.peerID) {
            browser.invitePeer(browsedPeer.peerID, to: newSession, withContext: nil, timeout: invitationTimeout)
        }
    }
    
    private func isPeerAvailableToConnect(peerID: MCPeerID) -> Bool {
        guard let browsedPeer = (browsedPeers.first { $0.peerID == peerID }) else {
            return false
        }
        return browsedPeer.currentStatus == .available
    }
    
    private func removeUnavailablePeer(peerID: MCPeerID) {
        browsedPeers.removeAll() {
            $0.peerID == peerID
        }
    }
    
    private func decidePeerStatus(_ peer: BrowsedPeer) {
        if SessionManager.shared.getMutualSession(with: peer.peerID) != nil {
            setStatus(for: peer.peerID, status: .connected)
        } else {
            setStatus(for: peer.peerID, status: .available)
        }
    }
    
    private func setStatus(for peerID: MCPeerID, status: BrowsedPeer.Status) {
        guard let index = (browsedPeers.firstIndex {
            $0.peerID == peerID
        }) else {
            print("Couldn't find peerID: \(peerID.displayName), so couldn't set its status")
            return
        }
        print("Set peer status of \(peerID.displayName) to \(status)")
        browsedPeers[index].currentStatus = status
    }
    
    private func showCouldntConnectError(failedToConnectPeer: MCPeerID) {
        couldntConnectMessage = "Couldn't connect to \(failedToConnectPeer.displayName)"
        couldntConnect = true
    }
}

extension BrowserViewModel: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("Found a new peer: \(peerID.displayName)")
        let browsedPeer = BrowsedPeer(peerID: peerID)
        browsedPeers.append(browsedPeer)
        decidePeerStatus(browsedPeer)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Peer \(peerID.displayName) is lost. Removing...")
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
                self?.showCouldntConnectError(failedToConnectPeer: peerID)
                self?.setStatus(for: peerID, status: .available)
            case .connecting:
                print("Connecting to \(peerID.displayName)")
                self?.setStatus(for: peerID, status: .connecting)
            case .connected:
                print("Connected to \(peerID.displayName)")
                self?.setStatus(for: peerID, status: .connected)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    let messageSender = MessageSender(companionPeer: peerID, sessionDelegate: self)
                    messageSender.sendSelfInfo()
                })
            @unknown default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Browser - Received data from \(peerID.displayName)")
        if let companion = (CompanionMP.getAll().first {
            $0.mcPeerID == peerID }) {
            ReceivedMessageHandler.handleReceivedUserMessage(messageData: data, from: companion)
        } else if let companion = ReceivedMessageHandler.handleCompanionInfo(data: data) {
            companion.saveLocally()
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
}
