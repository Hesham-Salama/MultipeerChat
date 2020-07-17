//
//  MoreView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct MoreView: View {
    private let moreVM = MoreViewModel()
    @EnvironmentObject var loginViewModel : LoginViewModel
    @State private var logoutClicked = false
    
    init() {
        UITableView.appearance().tableFooterView = UIView()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(moreVM.options.indices, id: \.self) { index in
                    Button (action: {
                        if index == 0 {
                            self.logoutClicked = true
                        }
                    }) {
                        Text(self.moreVM.options[index])
                    }
                }
            }.navigationBarTitle("More")
            .actionSheet(isPresented: $logoutClicked) {
                    ActionSheet(title: Text(moreVM.logoutMessage), buttons: [.default(Text("No")), .destructive(Text("Yes")) {
                        self.moreVM.removeDataRequested(loginVM: self.loginViewModel)
                }])
            }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
