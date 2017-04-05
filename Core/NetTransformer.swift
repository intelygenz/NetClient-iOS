//
//  NetTransformer.swift
//  Net
//
//  Created by Alex Rupérez on 5/4/17.
//
//

import Foundation

class NetTransformer {

    static func object<T>(object: Any?) throws -> T {
        if let responseObject = object as? T {
            return responseObject
        }
        var underlying: Error?
        if let data = object as? Data {
            if T.self == String.self, let stringObject = String(data: data, encoding: .utf8) as? T {
                return stringObject
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? T {
                    return jsonObject
                }
            }
            catch {
                underlying = error
            }
            do {
                if let propertyListObject = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? T {
                    return propertyListObject
                }
            }
            catch {
                underlying = error
            }
        }
        throw NetError.error(code: underlying?._code, message: "The data couldn’t be transformed into \(T.self).", headers: nil, object: object, underlying: underlying)
    }

}
