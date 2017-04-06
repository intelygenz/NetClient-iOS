//
//  NetError.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public enum NetError: Error {
    case net(code: Int?, message: String, headers: [AnyHashable : Any]?, object: Any?, underlying: Error?),
    parse(code: Int?, message: String, object: Any?, underlying: Error?)
}

extension NetError {

    public func object<T>() throws -> T {
        switch self {
        case .net(let code, _, _, let object, let underlying):
            return try transform(code, object, underlying)
        case .parse(let code, _, let object, let underlying):
            return try transform(code, object, underlying)
        }
    }

    private func transform<T>(_ code: Int?, _ object: Any?, _ underlying: Error?) throws -> T {
        do {
            return try NetTransformer.object(object: object)
        } catch {
            switch error as! NetError {
            case .parse(let transformCode, let message, let object, let transformUnderlying):
                throw NetError.parse(code: transformCode ?? code, message: message, object: object, underlying: transformUnderlying ?? underlying)
            default:
                throw error
            }
        }
    }
    
}

extension NetError {

    public var localizedDescription: String {
        switch self {
        case .net(_, let message, _, _, let underlying), .parse(_, let message, _, let underlying):
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
        case .net(let code, _, _, _, _), .parse(let code, _, _, _):
            if let code = code?.description {
                return code + " " + localizedDescription
            }
            return localizedDescription
        }
    }
    
}
