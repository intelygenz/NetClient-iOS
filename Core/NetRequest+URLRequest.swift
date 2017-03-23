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
        var method = NetMethod.GET
        if let methodString = urlRequest.httpMethod, let methodValue = NetMethod(rawValue: methodString) {
            method = methodValue
        }
        self.init(url, cache: NetCachePolicy(rawValue: urlRequest.cachePolicy.rawValue) ?? .useProtocolCachePolicy, timeout: urlRequest.timeoutInterval, mainDocumentURL: urlRequest.mainDocumentURL, serviceType: NetServiceType(rawValue: urlRequest.networkServiceType.rawValue) ?? .default, contentType: contentType, accept: accept, allowsCellularAccess: urlRequest.allowsCellularAccess, method: method, headers: urlRequest.allHTTPHeaderFields, body: urlRequest.httpBody, bodyStream: urlRequest.httpBodyStream, handleCookies: urlRequest.httpShouldHandleCookies, usePipelining: urlRequest.httpShouldUsePipelining)
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
        urlRequest.httpBody = body
        urlRequest.httpBodyStream = bodyStream
        urlRequest.httpShouldHandleCookies = handleCookies
        urlRequest.httpShouldUsePipelining = usePipelining
        return urlRequest
    }
    
}
