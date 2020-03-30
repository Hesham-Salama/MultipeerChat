//
//  PeerImageMessageView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct PeerImageMessageView : View {
    let messageImage: UIImage
    let isCurrentUser: Bool
    let userImage: Image
    
    init(messageImage: UIImage, isCurrentUser: Bool, userUIImage: UIImage?) {
        self.messageImage = messageImage
        self.isCurrentUser = isCurrentUser
        self.userImage = DefaultImageConstructor.get(uiimage: userUIImage)
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !isCurrentUser {
                self.userImage.peerImageModifier().frame(width: 40, height: 40, alignment: .center)
            } else {
                Spacer()
            }
            ContentImageMessageView(messageImage: messageImage, isCurrentUser: isCurrentUser)
        }
    }
}
