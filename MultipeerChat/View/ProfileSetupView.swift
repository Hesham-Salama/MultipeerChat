//
//  ProfileSetupView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/6/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject private var loginViewModel : LoginViewModel
    @State private var showImagePicker = false
    @State private var showErrorAlert = false
    @State private var uiimage = UIImage(named: "defaultProfile")
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Button(action: {
                self.showImagePicker.toggle()
            }) {
                DefaultImageConstructor.get(uiimage: uiimage)
                    .peerImageModifier().frame(width: 100.0, height: 100.0)
            }
            TextField("Enter your name here", text: $loginViewModel.name)
                .background(Color.clear)
                .multilineTextAlignment(.center)
            Button(action: {
                self.loginViewModel.attemptRegisteration(image: self.uiimage)
            }) {
                Text("Continue")
            }
        }.padding(.vertical, -150)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$uiimage, takePhoto: false)
        }.alert(isPresented: $loginViewModel.isErrorShown) {
            Alert(title: Text("Error"),
                  message: Text(loginViewModel.errorMessage))
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}
