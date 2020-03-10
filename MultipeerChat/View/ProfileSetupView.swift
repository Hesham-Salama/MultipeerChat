//
//  ProfileSetupView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/6/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ProfileSetupView: View {
    @EnvironmentObject private var userViewModel : UserViewModel
    @State private var showImagePicker = false
    @State private var showErrorAlert = false
    @State private var image = Image("defaultProfile")
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Button(action: {
                self.showImagePicker.toggle()
            }) {
                image
                    .resizable()
                    .renderingMode(.original)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 100.0, height: 100.0)
                    .scaledToFit()
            }
            TextField("Enter your name here", text: $userViewModel.name)
                .background(Color.clear)
                .multilineTextAlignment(.center)
            Button(action: {
                self.showErrorAlert = !self.userViewModel.attemptLogin()
            }) {
                Text("Continue")
            }
        }.padding(.vertical, -150)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image)
        }.alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text("Please enter a valid username."))
        }.onAppear {
            if let userImage = self.userViewModel.image {
                self.image = Image(uiImage: userImage)
            }
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}
