//
//  ProfileSetupView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/6/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ProfileSetupView: View {
    @State private var name: String = ""
    @State private var showImagePicker: Bool = false
    @State private var image: Image? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Button(action: {
              withAnimation {
                  self.showImagePicker.toggle()
              }
            }) {
                (image ?? Image("defaultProfile"))
                .resizable()
                .renderingMode(.original)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    .frame(width: 100.0, height: 100.0)
                .scaledToFit()
            }
            TextField("Enter your name here", text: $name)
                .background(Color.clear)
                .multilineTextAlignment(.center)
            
            Button(action: {
                print("button pressed")
            }) {
                Text("Continue")
            }
        }.padding(.vertical, -150)
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: self.$image)
        }
    }
}

struct ProfileSetupView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSetupView()
    }
}
