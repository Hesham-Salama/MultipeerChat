//
//  MainView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var loadingShown = false
    @State private var actionSheetShown = false
    @State private var browserShown = false
    @State private var chatsViewModel = ChatsViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                    if self.loadingShown {
                        ScanningView(cancelAction: {
                            withAnimation {
                                self.loadingShown.toggle()
                                self.chatsViewModel.hostingSessionCancelled()
                            }
                        }).frame(width: geometry.size.width, height: 50)
                    }
                }
                .navigationBarTitle("Chats")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.actionSheetShown.toggle()
                    }) {
                        Image(systemName: "plus")
                })
            }
            }.sheet(isPresented: $browserShown) {
                MCBrowser(session: self.chatsViewModel.session.mcSession, serviceType: self.chatsViewModel.serviceType)
            }.actionSheet(isPresented: $actionSheetShown) {
            ActionSheet(title: Text("Choose an option"), buttons: [.default(Text("Host a session")) {
                self.loadingShown = true
                self.chatsViewModel.hostingSessionClicked()
                }, .default(Text("Join a session")) {
                    self.browserShown.toggle()
                }, .cancel()])
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
