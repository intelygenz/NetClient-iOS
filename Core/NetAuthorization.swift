//
//  NetAuthorization.swift
//  Net
//
//  Created by Alex Rupérez on 26/3/17.
//
//

import Foundation

public enum NetAuthorization {
    case none, basic(user: String, password: String), bearer(token: String), custom(String)
}

extension NetAuthorization: Equatable {}

extension NetAuthorization: RawRepresentable {

    private struct StringValue {
        static let basic = "Basic "
        static let bearer = "Bearer "
    }

    public typealias RawValue = String

    public init(rawValue: RawValue) {
        self = .none
        if rawValue.hasPrefix(StringValue.basic) {
            let base64EncodedString = "\(rawValue[StringValue.basic.endIndex...])"
            if let authorizationData = Data(base64Encoded: base64EncodedString) {
                let authorizationComponents = String(data: authorizationData, encoding: .utf8)?.components(separatedBy: ":")
                if let user: String = authorizationComponents?.first, let password: String = authorizationComponents?.last, user != password {
                    self = .basic(user: user, password: password)
                }
            }
        } else if rawValue.hasPrefix(StringValue.bearer) {
            self = .bearer(token: "\(rawValue[StringValue.bearer.endIndex...])")
        } else {
            self = .custom(rawValue)
        }
    }

    public var rawValue: RawValue {
        switch self {
            case .basic(let user, let password):
                guard let data = "\(user):\(password)".data(using: .utf8) else {
                    return StringValue.basic
                }
                return "\(StringValue.basic)\(data.base64EncodedString())"
            case .bearer(let token):
                return "\(StringValue.bearer)\(token)"
            case .custom(let authorization):
                return authorization
            default:
                return ""
        }
    }

}
