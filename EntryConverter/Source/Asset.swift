//
//  Asset.swift
//  Lander Torah
//
//  Created by Yehoshua Levine on 01/07/2018.
//  Copyright © 2018 Sifra Digital. All rights reserved.
//

import UIKit

public class Asset: NSObject {
    
    public let id: Int
    public let created: Date
    public let updated: Date
    public let name: String
    public let mediaType: String
    public let url: String
    public let size: Int
    public let width: Int?
    public let height: Int?
    public let duration: Int?
    
    public init(id: Int, created: Date, updated: Date, name: String, mediaType: String, url: String, size: Int, width: Int?, height: Int?, duration: Int?) {
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
