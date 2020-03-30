//
//  ImagePickerCoordinator.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/30/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//
import SwiftUI

final class ImagePickerCoordinator: NSObject {
    
    @Binding var image: UIImage?
    var takePhoto: Bool
    
    init(image: Binding<UIImage?>, takePhoto: Bool) {
        _image = image
        self.takePhoto = takePhoto
    }
}

extension ImagePickerCoordinator: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        self.image = uiImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
