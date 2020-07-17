//
//  TabBarView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    private let mainView = MainView()
    private let moreView = MoreView()
    var body: some View {
        TabView {
            mainView
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Chat")
            }
            moreView
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
