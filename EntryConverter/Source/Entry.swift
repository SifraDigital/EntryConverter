//
//  Entry.swift
//  Lander Torah
//
//  Created by Yehoshua Levine on 01/07/2018.
//  Copyright © 2018 Sifra Digital. All rights reserved.
//

import UIKit

class Entry {
    
    private static let dateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        return formatter
    }()
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-ddX"
        return formatter
    }()
    
    let id: Int
    let created: Date
    let updated: Date
    let fields: [Field]
    
    init(id: Int, created: Date, updated: Date, fields: [Field]) {
        self.id = id
        self.created = created
        self.updated = updated
        self.fields = fields
    }
    
    func getString(_ key: String) -> String? {
        if let f = fields.first(where: {$0.key == key}) {
            return (f.value as! String)
        }
        return nil
    }
    
    func getInt(_ key: String) -> Int? {
        if let f = fields.first(where: {$0.key == key}) {
            if let s = f.value as? String {
                return Int(s)
            }
        }
        return nil
    }
    
    func getBool(_ key: String) -> Bool? {
        if let f = fields.first(where: {$0.key == key}) {
            if let s = f.value as? String {
                return s == "true"
            }
        }
        return nil
    }
    
    func getDate(_ key: String) -> Date? {
        if let f = fields.first(where: {$0.key == key}) {
            if let s = f.value as? String {
                let d = Entry.dateTimeFormatter.date(from: s)
                if d != nil {
                    return d
                }
                return Entry.dateFormatter.date(from: s)
            }
        }
        return nil
    }
    
    func getReference(_ key: String) -> Entry? {
        if let f = fields.first(where: {$0.key == key}) {
            return (f.value as! Entry)
        }
        return nil
    }
    
    func getReferenceArray(_ key: String) -> [Entry]? {
        if let f = fields.first(where: {$0.key == key}) {
            return (f.value as! [Entry])
        }
        return nil
    }
}
