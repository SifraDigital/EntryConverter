//
//  Asset.swift
//  Lander Torah
//
//  Created by Yehoshua Levine on 01/07/2018.
//  Copyright © 2018 Sifra Digital. All rights reserved.
//

import UIKit

class Asset: NSObject {
    
    let id: Int
    let created: Date
    let updated: Date
    let name: String
    let mediaType: String
    let url: String
    let size: Int
    let width: Int?
    let height: Int?
    let duration: Int?
    
    init(id: Int, created: Date, updated: Date, name: String, mediaType: String, url: String, size: Int, width: Int?, height: Int?, duration: Int?) {
        self.id = id
        self.created = created
        self.updated = updated
        self.name = name
        self.mediaType = mediaType
        self.url = url
        self.size = size
        self.width = width
        self.height = height
        self.duration = duration
    }

}