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
    let multipeerUser: CompanionMP
    var action: actionClosure
    private let image: Image
    
    init(multipeerUser: CompanionMP, action: actionClosure = nil) {
        self.multipeerUser = multipeerUser
        self.action = action
        self.image = DefaultImageConstructor.get(uiimage: multipeerUser.picture)
    }
    
    var body: some View {
            HStack {
                self.image.peerImageModifier().frame(width: 50, height: 50).padding()
                Text(self.multipeerUser.mcPeerID.displayName).padding()
            }
    }
}
