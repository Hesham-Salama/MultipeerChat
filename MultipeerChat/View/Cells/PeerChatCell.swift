//
//  PeerChatCell.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/26/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct PeerChatCell: View {
    typealias actionClosure = (() -> ())?
    let multipeerUser: MultipeerUser
    var action: actionClosure
    private let image: Image
    
    init(multipeerUser: MultipeerUser, action: actionClosure = nil) {
        self.multipeerUser = multipeerUser
        self.action = action
        if let image = multipeerUser.picture {
            self.image = Image(uiImage: image)
        } else {
            self.image = Image("defaultProfile")
        }
    }
    
    var body: some View {
            HStack {
                self.image.peerImageModifier().frame(width: 50, height: 50).padding()
                
                Text(self.multipeerUser.mcPeerID.displayName).padding()
            }
    }
}
