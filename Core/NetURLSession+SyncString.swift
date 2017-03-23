//
//  NetURLSession+SyncString.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func string(_ request: NetRequest, encoding: String.Encoding = .utf8) throws -> String? {
        return try string(request.urlRequest, encoding: encoding)
    }

    public func string(_ request: URLRequest, encoding: String.Encoding = .utf8) throws -> String? {
        guard let data = try data(request), data.count > 0 else {
            return nil
        }
        return string(data, encoding: encoding)
    }

    public func string(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, encoding: String.Encoding = .utf8) throws -> String? {
        return try string(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), encoding: encoding)
    }

    public func string(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, encoding: String.Encoding = .utf8) throws -> String? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try string(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, encoding: encoding)
    }

}
