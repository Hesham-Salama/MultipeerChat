//
//  PeerTextMessageView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct PeerTextMessageView : View {
    let message: String
    let isCurrentUser: Bool
    let userImage: Image
    
    init(message: String, isCurrentUser: Bool, userUIImage: UIImage?) {
        self.message = message
        self.isCurrentUser = isCurrentUser
        self.userImage = DefaultImageConstructor.get(uiimage: userUIImage)
    }
    
    var body: some View {
        HStack(spacing: 15) {
            if !isCurrentUser {
                self.userImage.peerImageModifier().frame(width: 40, height: 40)
            } else {
                Spacer()
            }
            ContentTextMessageView(contentMessage: message, isCurrentUser: isCurrentUser)
        }.frame(alignment: isCurrentUser ? .trailing : .leading)
    }
}
