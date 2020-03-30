//
//  ChatroomViewModel.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import MultipeerConnectivity

class ChatroomViewModel: NSObject, ObservableObject {
    
    let peer : MultipeerUser
    @Published var messages = [UserMessage]()
    @Published var errorAlertShown = false
    @Published var messageText = ""
    var errorMessage = ""
    private var currentPage = 0
    private let session: MCSession?
    
    lazy var otherPeerImage: UIImage? = {
        return peer.picture
    }()
    
    init(peer: MultipeerUser) {
        self.peer = peer
        session = SessionManager.shared.getMutualSession(with: peer.mcPeerID)
    }
    
    func getMoreMutualMessages(after time: TimeInterval? = nil) {
        let userMessages = UserMessage.getAll(from: peer.mcPeerID, after: time, paging: currentPage)
        if userMessages.count > 0 {
            currentPage += 1
            messages.insert(contentsOf: userMessages, at: 0)
        }
    }
    
    func sendTextMessage() {
        guard let session = session, session.connectedPeers.contains(peer.mcPeerID) else {
            errorMessage = "Couldn't send the message. The peer is disconnected."
            errorAlertShown = true
            return
        }
        MessageSender(session: session).sendMessage(text: messageText)
        messageText = ""
    }
    
    func sendMessage(image: UIImage) {
        guard let session = session, session.connectedPeers.count > 1 else {
            errorMessage = "Couldn't send the message. The peer is disconnected."
            errorAlertShown = true
            return
        }
        MessageSender(session: session).sendMessage(image: image)
    }
    
    func isCurrentUser(message: UserMessage) -> Bool {
        return message.senderPeerID == UserPeer.shared.peerID
    }
}

extension ChatroomViewModel: MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let message = MessageHandler.handleReceivedUserMessage(data: data, from: peerID)
        if peerID == peer.mcPeerID, let receivedMessage = message {
            messages.append(receivedMessage)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}
