//
//  MainView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var advertiserShown = false
    @State private var actionSheetShown = false
    @State private var browserShown = false
    @ObservedObject private var chatsViewModel = ChatsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                List(chatsViewModel.peers) {
                    peer in
                    NavigationLink(destination: ChatroomView(multipeerUser: peer)) {
                        PeerChatCell(multipeerUser: peer)
                    }
                }
                NavigationLink(destination: BrowserView(), isActive: self.$browserShown) {
                    EmptyView()
                }.hidden()
                NavigationLink(destination: AdvertiserView(), isActive: self.$advertiserShown) {
                    EmptyView()
                }.hidden()
            }
            .navigationBarTitle("Chats")
            .navigationBarItems(trailing:
                Button(action: {
                    self.actionSheetShown.toggle()
                }) {
                    Image(systemName: "plus")
            }).onAppear {
                self.reportOnAppear()
            }
        }.actionSheet(isPresented: self.$actionSheetShown) {
            ActionSheet(title: Text("Choose an option"), buttons: [.default(Text("Host a session")) {
                print("Hosting clicked")
                self.advertiserShown.toggle()
                }, .default(Text("Join a session")) {
                    print("Browsing clicked")
                    self.browserShown.toggle()
                }, .cancel()])
        }
    }
    
    func reportOnAppear() {
        print("Reloading peers")
        self.advertiserShown = false
        self.browserShown = false
        self.chatsViewModel.updatePeers()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
