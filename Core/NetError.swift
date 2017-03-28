//
//  NetError.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public enum NetError: Error {
    case error(code: Int?, message: String, underlying: Error?)
}

extension NetError {

    public var localizedDescription: String {
        switch self {
        case .error(_, let message, let underlying):
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
        case .error(let code, _, _):
            if let code = code?.description {
                return code + " " + localizedDescription
            }
            return localizedDescription
        }
    }
    
}
