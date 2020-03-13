//
//  ScanningView.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/12/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ScanningView: View {
    
    @State private var animate = true
    let cancelAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(Color(UIColor.systemBackground)).contrast(0.9)
            HStack {
                ActivityIndicator(style: .medium, animate: self.$animate).padding(.leading)
                Text("Searching for Peers...")
                Spacer()
                Button("Cancel") {
                    self.cancelAction?()
                }.padding(.trailing)
            }
        }
    }
}

struct ScanningView_Previews: PreviewProvider {
    static var previews: some View {
        ScanningView() {}
    }
}
