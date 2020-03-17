//
//  MCBrowser.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/14/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI
import MultipeerConnectivity

struct MCBrowser: UIViewControllerRepresentable {
    
    private let session: MCSession
    private let serviceType: String
    
    init(session: MCSession, serviceType: String) {
        self.session = session
        self.serviceType = serviceType
    }
    
    class Coordinator: NSObject, MCBrowserViewControllerDelegate, UINavigationControllerDelegate {
        var parent: MCBrowser
        
        init(_ browserViewController: MCBrowser) {
            self.parent = browserViewController
        }
        
        func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }
        
        func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
            browserViewController.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MCBrowserViewController {
        let browserVC = MCBrowserViewController(serviceType: serviceType, session: session)
        browserVC.maximumNumberOfPeers = 2
        browserVC.delegate = context.coordinator
        return browserVC
    }
    
    func updateUIViewController(_ uiViewController: MCBrowserViewController, context: Context) {
        
    }
}

