//
//  NetRequest+Build.swift
//  Net
//
//  Created by Alex Rupérez on 25/3/17.
//
//

import Foundation

extension NetRequest {

    public class Builder {

        public typealias BuildClosure = (Builder) -> Swift.Void

        public private(set) var url: URL

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

        public var authorization: NetAuthorization?

        public init(_ url: URL, buildClosure: BuildClosure? = nil) {
            self.url = url
            buildClosure?(self)
        }

        public convenience init?(_ urlString: String, buildClosure: BuildClosure? = nil) {
            guard let url = URL(string: urlString) else {
                return nil
            }
            self.init(url, buildClosure: buildClosure)
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

        public func addHeader(_ key: String, value: String?) -> Self {
            if headers == nil {
                headers = [:]
            }
            headers?[key] = value
            return self
        }

        public func setBody(_ body: Data?) -> Self {
            self.body = body
            return self
        }

        public func setURLParameters(_ urlParameters: [String: Any]?, resolvingAgainstBaseURL: Bool = false) -> Self {
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL) {
                components.percentEncodedQuery = nil
                if let urlParameters = urlParameters, urlParameters.count > 0 {
                    components.percentEncodedQuery = query(urlParameters)
                }
                if let url = components.url {
                    self.url = url
                }
            }
            return self
        }

        public func addURLParameter(_ key: String, value: Any?, resolvingAgainstBaseURL: Bool = false) -> Self {
            guard let value = value else {
                return self
            }
            if var components = URLComponents(url: url, resolvingAgainstBaseURL: resolvingAgainstBaseURL) {
                let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + query([key: value])
                components.percentEncodedQuery = percentEncodedQuery
                if let url = components.url {
                    self.url = url
                }
            }
            return self
        }

        public func setFormParameters(_ formParameters: [String: Any]?, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) -> Self {
            guard let formParameters = formParameters else {
                return self
            }
            body = query(formParameters).data(using: encoding, allowLossyConversion: allowLossyConversion)
            if contentType == nil {
                contentType = .formURL
            }
            return self
        }

        public func setStringBody(_ stringBody: String?, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) -> Self {
            guard let stringBody = stringBody else {
                return self
            }
            body = stringBody.data(using: encoding, allowLossyConversion: allowLossyConversion)
            return self
        }

        public func setJSONBody(_ jsonBody: Any?, options: JSONSerialization.WritingOptions = .prettyPrinted) throws -> Self {
            guard let jsonBody = jsonBody else {
                return self
            }
            body = try JSONSerialization.data(withJSONObject: jsonBody, options: options)
            if contentType == nil {
                contentType = .json
            }
            return self
        }

        public func setPListBody(_ pListBody: Any?, format: PropertyListSerialization.PropertyListFormat = .xml, options: PropertyListSerialization.WriteOptions = 0) throws -> Self {
            guard let pListBody = pListBody else {
                return self
            }
            body = try PropertyListSerialization.data(fromPropertyList: pListBody, format: format, options: options)
            if contentType == nil {
                contentType = .plist
            }
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

        public func setBasicAuthorization(user: String, password: String) -> Self {
            authorization = .basic(user: user, password: password)
            return self
        }

        public func setBearerAuthorization(token: String) -> Self {
            authorization = .bearer(token: token)
            return self
        }

        public func build() -> NetRequest {
            return NetRequest(self)
        }

    }

    public static func builder(_ url: URL, buildClosure: Builder.BuildClosure? = nil) -> Builder {
        return Builder(url, buildClosure: buildClosure)
    }

    public static func builder(_ urlString: String, buildClosure: Builder.BuildClosure? = nil) -> Builder? {
        return Builder(urlString, buildClosure: buildClosure)
    }

    public init(_ builder: Builder) {
        self.init(builder.url, cache: builder.cache ?? .useProtocolCachePolicy, timeout: builder.timeout ?? 60, mainDocumentURL: builder.mainDocumentURL, serviceType: builder.serviceType ?? .default, contentType: builder.contentType, accept: builder.accept, allowsCellularAccess: builder.allowsCellularAccess ?? true, method: builder.method ?? .GET, headers: builder.headers, body: builder.body, bodyStream: builder.bodyStream, handleCookies: builder.handleCookies ?? true, usePipelining: builder.usePipelining ?? true, authorization: builder.authorization ?? .none)
    }
    
}

extension NetRequest.Builder {

    fileprivate func query(_ parameters: [String: Any]) -> String {
        var components = [(String, String)]()

        for key in parameters.keys.sorted(by: <) {
            if let value = parameters[key] {
                components += queryComponents(key, value: value)
            }
        }

        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }

    fileprivate func queryComponents(_ key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []

        if let dictionary = value as? [String: Any] {
            for (dictionaryKey, value) in dictionary {
                components += queryComponents("\(key)[\(dictionaryKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value: value)
            }
        } else if let value = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(value) {
                components.append((escape(key), escape((value.boolValue ? "1" : "0"))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape((bool ? "1" : "0"))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }

        return components
    }

    fileprivate func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
    }

}
