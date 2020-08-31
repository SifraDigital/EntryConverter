//
//  Converter.swift
//  EntryConverter
//
//  Created by Chaim Gross on 24/08/2020.
//  Copyright © 2020 Chaim Gross. All rights reserved.
//

import Foundation
import Runtime
import SwiftyJSON


public class EntryConverter {
    
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
    
    public static func fromJSON(json: JSON, clazz: NSObject.Type) -> Any? {
        let entry = deserializeEntry(json)
        return fromEntry(entry: entry, clazz: clazz)
    }
    
    private static func deserializeEntry(_ json: JSON) -> Entry {
        let id = json["id"].intValue
        let created = getDate(json["created"].stringValue)!
        let updated = getDate( json["updated"].stringValue)!
        let fields = json["fields"].arrayValue.map { deserializeField($0) }.compactMap { $0 }
        
        return Entry(id: id, created: created, updated: updated, fields: fields)
    }
    
    private static func getDate(_ dateString: String) -> Date? {
        let d = EntryConverter.dateTimeFormatter.date(from: dateString)
        if d != nil {
            return d
        }
        return EntryConverter.dateFormatter.date(from: dateString)
    }
    
    private static func deserializeField(_ json: JSON) -> Field? {
        let key = json["key"].stringValue
        let type = json["type"].stringValue
        if let value = deserializeValue(json["value"]) {
            return Field(key: key, value: value, type: type)
        }
        return nil
    }
    
    private static func deserializeValue(_ json: JSON) -> Any? {
        if (!json.exists()) {
            return nil
        }
        if let s = json.string {
            return s
        }
        else if let array = json.array {
            return array.map { deserializeValue($0) }
        }
        else {
            return deserializeEntry(json)
        }
    }
    
    public static func fromEntry(entry: Entry, clazz: NSObject.Type) -> Any? {
        do {
            var result = try createInstance(of: clazz)
            let info = try typeInfo(of: clazz)
            for property in info.properties {
                if entry.fields.map({$0.key}).contains(property.name) || property.name == "itemDescription" {
                    switch property.type {
                    case is Int.Type, is Optional<Int>.Type:
                        //result.setValue(entry.getInt(property.name), forKey: property.name)
                        if property.name == "id" {
                            try property.set(value: entry.id, on: &result)
                        }
                        else {
                            try property.set(value: entry.getInt(property.name), on: &result)
                        }
                    case is Bool.Type:
                        try property.set(value: entry.getBool(property.name), on: &result)
                    case is Optional<String>.Type, is String.Type:
                        if property.name == "itemDescription" {
                            try property.set(value: entry.getString("description") as Any, on: &result)
                        }
                        else {
                            try property.set(value: entry.getString(property.name) as Any, on: &result)
                        }
                    case is Date.Type:
                        if property.name == "created" {
                            try property.set(value: entry.created, on: &result)
                        }
                        else if property.name == "updated" {
                            try property.set(value: entry.updated, on: &result)
                        }
                        else {
                            try property.set(value: entry.getDate(property.name), on: &result)
                        }
                    default:
                        let fn_info = try typeInfo(of: property.type)
                        let type = fn_info.genericTypes
                        var innerType = fn_info.genericTypes.first
                        if innerType == nil {
                            innerType = fn_info.type
                        }
                        if fn_info.name.contains("Array"), var innerType = innerType {
                            if fn_info.mangledName == "Optional" {
                                let dn_info = try typeInfo(of: innerType)
                                if let innerInner = dn_info.genericTypes.first {
                                    innerType = innerInner
                                }
                            }
                            if let entryArray = entry.getReferenceArray(property.name) {
                                let mappedItems = entryArray.compactMap{fromEntry(entry: $0, clazz:innerType as! NSObject.Type)}
                                try property.set(value: mappedItems, on: &result)
                            }
                        }
                        else if let innerEntry = entry.getReference(property.name) {
                            try property.set(value: fromEntry(entry: innerEntry, clazz: innerType as! NSObject.Type), on: &result)
                        }
                        print(property.type)
                    }
                }
            }
            return result
        }
        catch {
        }
        return nil
    }
}
