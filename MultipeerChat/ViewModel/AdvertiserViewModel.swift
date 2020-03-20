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
    var startErrorMessage = ""
    var peerWantsToConnectMessage = ""
    private let advertiser: MCNearbyServiceAdvertiser
    private var acceptRequest: (() -> ())?
    private var declineRequest: (() -> ())?
    
    private lazy var session: MCSession = {
        let newSession = MCSession(peer: advertiser.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        return newSession
    }()
    
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
}

extension AdvertiserViewModel: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let peers = MultipeerUser.getAll().filter { $0.mcPeerID.hashValue == peerID.hashValue }
        if peers.count == 1 {
            print("Already added")
            invitationHandler(true, session)
        } else {
            print("New peer.")
            acceptRequest = {
                invitationHandler(true, self.session)
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
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        startErrorMessage = error.localizedDescription
        didNotStartAdvertising = true
    }
}

