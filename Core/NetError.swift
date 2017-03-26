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
            if let localizedDescription = underlying?.localizedDescription {
                return message + " " + localizedDescription
            }
            return message
        }
    }

}
