//
//  MainView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    @State private var loadingHidden = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    Spacer()
                    if !self.loadingHidden {
                        ScanningView {
                            withAnimation {
                                self.loadingHidden.toggle()
                            }
                        }.frame(width: geometry.size.width, height: 50)
                    }
                }
                .navigationBarTitle("Chats")
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
