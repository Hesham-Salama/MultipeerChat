//
//  DefaultImageConstructor.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/28/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//

import SwiftUI

class DefaultImageConstructor {
    
    private static let defaultImageName = "defaultProfile"
    
    static func get(uiimage: UIImage?) -> Image {
        if let uiimage = uiimage {
            return Image(uiImage: uiimage)
        }
        return Image(defaultImageName)
    }
}
