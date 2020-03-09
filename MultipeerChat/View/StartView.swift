//
//  StartView.swift
//  MultipeerChat
//
//  Created by Hesham on 3/9/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct StartView: View {
    
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        if userViewModel.isLoggedIn {
            return AnyView(TabBarView())
        } else {
            return AnyView(ProfileSetupView())
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
