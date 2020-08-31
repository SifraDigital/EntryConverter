//
//  Field.swift
//  Lander Torah
//
//  Created by Yehoshua Levine on 01/07/2018.
//  Copyright © 2018 Sifra Digital. All rights reserved.
//

import UIKit

class Field {
    
    let key: String
    let value: Any
    let type: String
    
    init(key: String, value: Any, type: String) {
        self.key = key
        self.value = value
        self.type = type
    }

}
