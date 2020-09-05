//
//  ChatroomView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/27/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ChatroomView: View {
    let companion: CompanionMP
    @ObservedObject private var chatroomVM: ChatroomViewModel
    
    init(multipeerUser: CompanionMP) {
        self.companion = multipeerUser
        chatroomVM = ChatroomViewModel(peer: multipeerUser)
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(chatroomVM.messages) { msg in
                    self.getMessageView(message: msg)
                }
            }
            HStack {
                TextField("Message", text: $chatroomVM.messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxHeight: CGFloat(60))
                Button(action: {
                    self.chatroomVM.sendTextMessage()
                }) {
                    Text("Send")
                }
            }.frame(maxHeight: CGFloat(60)).padding()
        }.onAppear() {
            self.chatroomVM.loadInitialMessages()
        }
    }
    
    func getMessageView(message: MPMessage) -> AnyView {
        if let image = UIImage(data: message.data) {
            return AnyView(PeerImageMessageView(messageImage: image, isCurrentUser: chatroomVM.isCurrentUser(message: message), userUIImage: chatroomVM.companion.picture))
        } else if let text = String.init(data: message.data, encoding: .utf8) {
            return AnyView(PeerTextMessageView(message: text, isCurrentUser: chatroomVM.isCurrentUser(message: message), userUIImage: chatroomVM.companion.picture))
        } else {
            return AnyView(EmptyView())
        }
    }
}
