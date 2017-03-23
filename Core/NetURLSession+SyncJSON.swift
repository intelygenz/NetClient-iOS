//
//  NetURLSession+SyncJSON.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func json(_ request: NetRequest, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        return try json(request.urlRequest, options: options)
    }

    public func json(_ request: URLRequest, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        guard let data = try data(request), data.count > 0 else {
            return nil
        }
        return try json(data, options: options)
    }

    public func json(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        return try json(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options)
    }

    public func json(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try json(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options)
    }

}
