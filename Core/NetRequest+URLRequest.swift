//
//  NetRequest+URLRequest.swift
//  Net
//
//  Created by Alex Rupérez on 23/3/17.
//
//

import Foundation

extension NetRequest {

    private struct HTTPHeader {
        static let contentType = "Content-Type"
        static let accept = "Accept"
        static let acceptEncoding = "Accept-Encoding"
        static let authorization = "Authorization"
    }

    public init?(_ urlRequest: URLRequest) {
        guard let url = urlRequest.url else {
            return nil
        }
        var contentType: NetContentType? = nil
        if let contentTypeValue = urlRequest.value(forHTTPHeaderField: HTTPHeader.contentType) {
            contentType = NetContentType(rawValue: contentTypeValue)
        }
        var accept: NetContentType? = nil
        if let acceptValue = urlRequest.value(forHTTPHeaderField: HTTPHeader.accept) {
            accept = NetContentType(rawValue: acceptValue)
        }
        var acceptEncoding: [NetContentEncoding]? = nil
        if let acceptEncodingValue = urlRequest.value(forHTTPHeaderField: HTTPHeader.acceptEncoding) {
            acceptEncoding = acceptEncodingValue.components(separatedBy: ", ").flatMap({NetContentEncoding(rawValue: $0)})
        }
        var authorization = NetAuthorization.none
        if let authorizationValue = urlRequest.value(forHTTPHeaderField: HTTPHeader.authorization) {
            authorization = NetAuthorization(rawValue: authorizationValue)
        }
        var method = NetMethod.GET
        if let methodString = urlRequest.httpMethod, let methodValue = NetMethod(rawValue: methodString) {
            method = methodValue
        }
        self.init(url, cache: NetCachePolicy(rawValue: urlRequest.cachePolicy.rawValue) ?? .useProtocolCachePolicy, timeout: urlRequest.timeoutInterval, mainDocumentURL: urlRequest.mainDocumentURL, serviceType: NetServiceType(rawValue: urlRequest.networkServiceType.rawValue) ?? .default, contentType: contentType, accept: accept, acceptEncoding: acceptEncoding, allowsCellularAccess: urlRequest.allowsCellularAccess, method: method, headers: urlRequest.allHTTPHeaderFields, body: urlRequest.httpBody, bodyStream: urlRequest.httpBodyStream, handleCookies: urlRequest.httpShouldHandleCookies, usePipelining: urlRequest.httpShouldUsePipelining, authorization: authorization)
    }

    public var urlRequest: URLRequest {
        var urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy(rawValue: cache.rawValue) ?? .useProtocolCachePolicy, timeoutInterval: timeout)
        urlRequest.mainDocumentURL = mainDocumentURL
        urlRequest.networkServiceType = URLRequest.NetworkServiceType(rawValue: serviceType.rawValue) ?? .default
        urlRequest.allowsCellularAccess = allowsCellularAccess
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.setValue(contentType?.rawValue, forHTTPHeaderField: HTTPHeader.contentType)
        urlRequest.setValue(accept?.rawValue, forHTTPHeaderField: HTTPHeader.accept)
        urlRequest.setValue(acceptEncoding?.flatMap({$0.rawValue}).joined(separator: ", "), forHTTPHeaderField: HTTPHeader.acceptEncoding)
        if authorization != .none {
            urlRequest.setValue(authorization.rawValue, forHTTPHeaderField: HTTPHeader.authorization)
        }
        urlRequest.httpBody = body
        urlRequest.httpBodyStream = bodyStream
        urlRequest.httpShouldHandleCookies = handleCookies
        urlRequest.httpShouldUsePipelining = usePipelining
        return urlRequest
    }
    
}

extension URLRequest {

    public var netRequest: NetRequest? {
        return NetRequest(self)
    }

}
