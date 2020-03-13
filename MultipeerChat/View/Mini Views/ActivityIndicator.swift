//
//  ActivityIndicator.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/12/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style
    @Binding var animate: Bool

    private let spinner: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView(style: .medium))

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        spinner.style = style
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        animate ? uiView.startAnimating() : uiView.stopAnimating()
    }

    func configure(_ indicator: (UIActivityIndicatorView) -> Void) -> some View {
        indicator(spinner)
        return self
    }
}
