//
//  NetError.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public enum NetError: Error {
    case error(code: Int?, message: String, headers: [AnyHashable : Any]?, object: Any?, underlying: Error?)
}

extension NetError {

    public func object<T>() throws -> T {
        switch self {
        case .error(let code, _, let headers, let object, let underlying):
            do {
                return try NetTransformer.object(object: object)
            } catch {
                switch error as! NetError {
                case .error(let transformCode, let message, _, let object, let transformUnderlying):
                    throw NetError.error(code: transformCode ?? code, message: message, headers: headers, object: object, underlying: transformUnderlying ?? underlying)
                }
            }
        }
    }
    
}

extension NetError {

    public var localizedDescription: String {
        switch self {
        case .error(_, let message, _, _, let underlying):
            if let localizedDescription = underlying?.localizedDescription, localizedDescription != message {
                return message + " " + localizedDescription
            }
            return message
        }
    }

}

extension NetError: CustomStringConvertible {

    public var description: String {
        return localizedDescription
    }

}

extension NetError: CustomDebugStringConvertible {

    public var debugDescription: String {
        switch self {
        case .error(let code, _, _, _, _):
            if let code = code?.description {
                return code + " " + localizedDescription
            }
            return localizedDescription
        }
    }
    
}
