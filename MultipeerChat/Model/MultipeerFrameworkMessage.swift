//
//  MultipeerFrameworkMessage.swift
//  MultipeerChat
//
//  Created by Hesham Salama on 3/24/20.
//  Copyright © 2020 Hesham Salama. All rights reserved.
//
import Foundation

struct MultipeerFrameworkMessage: Codable {
    let data: Data?
    let contentType: MessageContentType
    let commuType: CommunicationType
}

enum MessageContentType: Int, Codable {
    case image
    case text
}

enum CommunicationType: Int, Codable {
    case system
    case user
}
