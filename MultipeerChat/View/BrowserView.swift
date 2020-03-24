//
//  BrowserView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/20/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct BrowserView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var browserVM = BrowserViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Available Peers")) {
                ForEach(browserVM.availablePeers) { peer in
                    BrowsedPeerCell(buttonText: peer.peerID.displayName, statusText: peer.status == .connecting ? "Connecting..." : "") {
                        self.browserVM.peerClicked(peer: peer.peerID)
                    }
                }
            }.alert(isPresented: $browserVM.couldntConnect) {
                Alert(title: Text("Error"), message: Text(browserVM.couldntConnectMessage), dismissButton: .default(Text("OK")))
            }
            Section(header: Text("Connected Peers")) {
                ForEach(browserVM.connectedPeers) { peer in
                    BrowsedPeerCell(buttonText: peer.peerID.displayName, statusText: "")
                }
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle(Text("Peer Search"))
        .onAppear {
            self.browserVM.startBrowsing()
        }
        .onDisappear {
            self.browserVM.stopBrowsing()
        }.alert(isPresented: $browserVM.didNotStartBrowsing) {
            Alert(title: Text("Search Error"), message: Text(browserVM.startErrorMessage), dismissButton: .default( Text("OK"), action: {
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
    }
}

struct BrowserView_Previews: PreviewProvider {
    static var previews: some View {
        BrowserView()
    }
}
