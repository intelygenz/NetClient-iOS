//
//  NetResponse.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public struct NetResponse {

    public let url: URL?

    public let mimeType: String?

    public let contentLength: Int64?

    public let textEncoding: String?

    public let filename: String?

    public let statusCode: Int?

    public let headers: [AnyHashable : Any]?

    public let localizedDescription: String?

    fileprivate let responseObject: Any?

}

extension NetResponse {

    public init(_ url: URL? = nil, mimeType: String? = nil, contentLength: Int64 = -1, textEncoding: String? = nil, filename: String? = nil, statusCode: Int? = nil, headers: [AnyHashable : Any]? = nil, localizedDescription: String? = nil, responseObject: Any? = nil) {
        self.url = url
        self.mimeType = mimeType
        self.contentLength = contentLength != -1 ? contentLength : nil
        self.textEncoding = textEncoding
        self.filename = filename
        self.statusCode = statusCode
        self.headers = headers
        self.localizedDescription = localizedDescription
        self.responseObject = responseObject
    }

}

extension NetResponse {

    public func object<T>() throws -> T {
        if let responseObject = responseObject as? T {
            return responseObject
        }
        if let data = responseObject as? Data {
            if T.self == String.self, let stringObject = String(data: data, encoding: .utf8) as? T {
                return stringObject
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? T {
                    return jsonObject
                }
            }
            catch {}
            do {
                if let propertyListObject = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? T {
                    return propertyListObject
                }
            }
            catch {}
        }
        throw NetError.error(code: nil, message: "The data couldn’t be transformed into \(T.self).", underlying: nil)
    }

}

extension NetResponse: Equatable {

    public static func ==(lhs: NetResponse, rhs: NetResponse) -> Bool {
        guard lhs.url != nil && rhs.url != nil else {
            return false
        }
        return lhs.url == rhs.url
    }

}
