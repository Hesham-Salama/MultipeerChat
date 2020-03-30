//
//  ContentMessageView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ContentTextMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}
