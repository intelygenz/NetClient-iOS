//
//  NetURLSession+AsyncPropertyList.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func propertyList(_ request: NetRequest, options: PropertyListSerialization.ReadOptions = [], completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return propertyList(request.urlRequest, options: options, completion: completion)
    }

    public func propertyList(_ request: URLRequest, options: PropertyListSerialization.ReadOptions = [], completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return data(request, completion: { (data, response, error) in
            guard let data = data, data.count > 0 else {
                completion(nil, response, error)
                return
            }
            do {
                let propertyListObject = try self.propertyList(data, options: options)
                completion(propertyListObject, response, error)
            } catch {
                completion(nil, response, self.netError(error))
            }
        })
    }

    public func propertyList(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: PropertyListSerialization.ReadOptions = [], completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return propertyList(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options, completion: completion)
    }

    public func propertyList(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: PropertyListSerialization.ReadOptions = [], completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return propertyList(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options, completion: completion)
    }
    
}
