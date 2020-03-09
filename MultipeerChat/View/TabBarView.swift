//
//  TabBarView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Chat")
            }
            MoreView()
                .tabItem {
                    Image(systemName: "ellipsis.circle.fill")
                    Text("More")
            }
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
