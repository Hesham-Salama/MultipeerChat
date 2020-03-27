//
//  Image+extension.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/26/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

extension Image {
    func peerImageModifier() -> some View {
        self
            .resizable()
            .renderingMode(.original)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            .scaledToFit()
    }
}
