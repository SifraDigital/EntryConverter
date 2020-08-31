//
//  Converter.swift
//  EntryConverter
//
//  Created by Chaim Gross on 24/08/2020.
//  Copyright © 2020 Chaim Gross. All rights reserved.
//

import Foundation
import Runtime

public class EntryConverter {
     public static func fromEntry(entry: Entry, clazz: NSObject.Type) -> Any? {
        do {
            var result = try createInstance(of: clazz)
            let info = try typeInfo(of: clazz)
            for property in info.properties {
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
                    try property.set(value: entry.getString(property.name) as Any, on: &result)
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
            return result
        }
        catch {
        }
        return nil
    }
}
