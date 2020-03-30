//
//  ContentImageMessageView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ContentImageMessageView: View {
    
    let messageImage: UIImage
    let isCurrentUser: Bool
    
    var body: some View {
        Image(uiImage: messageImage)
            .padding(10)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
            .frame(width: 150, height: 150)
    }
}
