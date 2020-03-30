//
//  ImagePicker.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/6/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    var takePhoto: Bool
    
    func makeCoordinator() -> ImagePickerCoordinator {
        ImagePickerCoordinator(image: $image, takePhoto: takePhoto)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = context.coordinator
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return pickerController }
        
        switch self.takePhoto {
        case true:
            pickerController.sourceType = .camera
        case false:
            pickerController.sourceType = .photoLibrary
        }
        
        pickerController.allowsEditing = true
        return pickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
