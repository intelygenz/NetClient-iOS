//
//  NetURLSession+SyncPropertyList.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func propertyList(_ request: NetRequest, options: PropertyListSerialization.ReadOptions = []) throws -> Any? {
        return try propertyList(request.urlRequest, options: options)
    }

    public func propertyList(_ request: URLRequest, options: PropertyListSerialization.ReadOptions = []) throws -> Any? {
        guard let data = try data(request), data.count > 0 else {
            return nil
        }
        return try propertyList(data, options: options)
    }

    public func propertyList(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: PropertyListSerialization.ReadOptions = []) throws -> Any? {
        return try propertyList(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options)
    }

    public func propertyList(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: PropertyListSerialization.ReadOptions = []) throws -> Any? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try propertyList(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options)
    }
    
}
