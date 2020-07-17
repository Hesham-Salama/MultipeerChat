//
//  AdvertiserViewModel.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/20/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class AdvertiserViewModel: NSObject, ObservableObject {
    @Published var didNotStartAdvertising = false
    @Published var shouldShowConnectAlert = false
    @Published var showPeerConnectedAlert = false
    var startErrorMessage = ""
    var peerWantsToConnectMessage = ""
    var peerConnectedSuccessfully = ""
    private let advertiser: MCNearbyServiceAdvertiser
    private var acceptRequest: (() -> ())?
    private var declineRequest: (() -> ())?
    
    private var newSession: MCSession {
        let session = SessionManager.shared.newSession
        session.delegate = self
        return session
    }
    
    override init() {
        guard let peerID = UserPeer.shared.peerID else {
            fatalError("No PeerID detected!")
        }
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: MultipeerConstants.serviceType)
        super.init()
        advertiser.delegate = self
    }
    
    func startAdvertising() {
        advertiser.startAdvertisingPeer()
    }
    
    func stopAdvertising() {
        advertiser.stopAdvertisingPeer()
    }
    
    func replyToRequest(isAccepted: Bool) {
        isAccepted ? acceptRequest?() : declineRequest?()
    }
    
    private func sendUserInfo(session: MCSession) {
        guard let peerID = UserPeer.shared.peerID else {
            return
        }
        let image = (MultipeerUser.getAll().filter { $0.mcPeerID == peerID }).first?.picture
        let messageSender = MessageSender(session: session)
        print("Sending user info of \(peerID.displayName)")
        messageSender.sendProfilePicture(image: image)
    }
    
    private func handlePeerInvitation(_ peerID: MCPeerID, _ invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        acceptRequest = {
            invitationHandler(true, self.newSession)
            print("Accepted Request")
        }
        declineRequest = {
            invitationHandler(false, nil)
            print("Declined Request")
        }
        peerWantsToConnectMessage = "\(peerID.displayName) wants to chat with you."
        shouldShowConnectAlert = true
    }
}

extension AdvertiserViewModel: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        handlePeerInvitation(peerID, invitationHandler)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        startErrorMessage = error.localizedDescription
        didNotStartAdvertising = true
    }
}

extension AdvertiserViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async { [weak self] in
            if state == .connected {
                self?.peerConnectedSuccessfully = "\(peerID.displayName) is connected successfully."
                self?.showPeerConnectedAlert = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        ReceivedMessageHandler.handle(data: data, from: peerID)
        sendUserInfo(session: session)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
