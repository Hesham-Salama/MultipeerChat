//
//  AdvertiserView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/20/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct AdvertiserView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var isAnimating = true
    @ObservedObject var advertiserVM = AdvertiserViewModel()
    
    var body: some View {
        VStack {
            ActivityIndicator(style: .large, animate: $isAnimating)
                .alert(isPresented: $advertiserVM.shouldShowConnectAlert) {
                Alert(title: Text("Invitation"), message: Text(advertiserVM.peerWantsToConnectMessage), primaryButton: .default(Text("Accept"), action: {
                    self.advertiserVM.replyToRequest(isAccepted: true)
                }), secondaryButton: .cancel(Text("Decline"), action: {
                    self.advertiserVM.replyToRequest(isAccepted: false)
                }))
            }
            Text("Waiting for peers...")
                .alert(isPresented: $advertiserVM.didNotStartAdvertising) {
                Alert(title: Text("Hosting Error"), message: Text(advertiserVM.startErrorMessage), dismissButton: .default( Text("OK"), action: {
                    self.presentationMode.wrappedValue.dismiss()
                }))
            }
        }.navigationBarTitle(Text("Hosting"))
        .onAppear {
            self.advertiserVM.startAdvertising()
        }
        .onDisappear {
            self.advertiserVM.stopAdvertising()
        }
    }
}

struct AdvertiserView_Previews: PreviewProvider {
    static var previews: some View {
        AdvertiserView()
    }
}
