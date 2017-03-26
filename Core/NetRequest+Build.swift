//
//  NetRequest+Build.swift
//  Net
//
//  Created by Alex Rupérez on 25/3/17.
//
//

import Foundation

public extension NetRequest {

    public class Build {

        public typealias BuildClosure = (Build) -> ()

        public let url: URL

        public var cache: NetRequest.NetCachePolicy?

        public var timeout: TimeInterval?

        public var mainDocumentURL: URL?

        public var serviceType: NetRequest.NetServiceType?

        public var contentType: NetContentType?

        public var accept: NetContentType?

        public var allowsCellularAccess: Bool?

        public var method: NetRequest.NetMethod?

        public var headers: [String : String]?

        public var body: Data?

        public var bodyStream: InputStream?

        public var handleCookies: Bool?
        
        public var usePipelining: Bool?

        public init(_ url: URL, builder: BuildClosure? = nil) {
            self.url = url
            builder?(self)
        }

        public convenience init?(_ urlString: String, builder: BuildClosure? = nil) {
            guard let url = URL(string: urlString) else {
                return nil
            }
            self.init(url, builder: builder)
        }

        public func setCache(_ cache: NetRequest.NetCachePolicy?) -> Self {
            self.cache = cache
            return self
        }

        public func setTimeout(_ timeout: TimeInterval?) -> Self {
            self.timeout = timeout
            return self
        }

        public func setMainDocumentURL(_ mainDocumentURL: URL?) -> Self {
            self.mainDocumentURL = mainDocumentURL
            return self
        }

        public func setServiceType(_ serviceType: NetRequest.NetServiceType?) -> Self {
            self.serviceType = serviceType
            return self
        }

        public func setContentType(_ contentType: NetContentType?) -> Self {
            self.contentType = contentType
            return self
        }

        public func setAccept(_ accept: NetContentType?) -> Self {
            self.accept = accept
            return self
        }

        public func setAllowsCellularAccess(_ allowsCellularAccess: Bool?) -> Self {
            self.allowsCellularAccess = allowsCellularAccess
            return self
        }

        public func setMethod(_ method: NetRequest.NetMethod?) -> Self {
            self.method = method
            return self
        }

        public func setHeaders(_ headers: [String : String]?) -> Self {
            self.headers = headers
            return self
        }

        public func setBody(_ body: Data?) -> Self {
            self.body = body
            return self
        }

        public func setBodyStream(_ bodyStream: InputStream?) -> Self {
            self.bodyStream = bodyStream
            return self
        }

        public func setHandleCookies(_ handleCookies: Bool?) -> Self {
            self.handleCookies = handleCookies
            return self
        }

        public func setUsePipelining(_ usePipelining: Bool?) -> Self {
            self.usePipelining = usePipelining
            return self
        }

        public func build() -> NetRequest {
            return NetRequest(self)
        }

    }

    public init(_ builder: Build) {
        self.init(builder.url, cache: builder.cache ?? .useProtocolCachePolicy, timeout: builder.timeout ?? 30, mainDocumentURL: builder.mainDocumentURL, serviceType: builder.serviceType ?? .default, contentType: builder.contentType, accept: builder.accept, allowsCellularAccess: builder.allowsCellularAccess ?? true, method: builder.method ?? .GET, headers: builder.headers, body: builder.body, bodyStream: builder.bodyStream, handleCookies: builder.handleCookies ?? true, usePipelining: builder.usePipelining ?? true)
    }
    
}
