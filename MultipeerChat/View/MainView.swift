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
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                    if self.loadingShown {
                        ScanningView {
                            withAnimation {
                                self.loadingShown.toggle()
                            }
                        }.frame(width: geometry.size.width, height: 50)
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
        }.actionSheet(isPresented: $actionSheetShown) {
            ActionSheet(title: Text("Choose an option"), buttons: [.default(Text("Host a session")) {
                self.loadingShown.toggle()
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
