//
//  NetURLSession+AsyncJSON.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func json(_ request: NetRequest, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return json(request.urlRequest, options: options, completion: completion)
    }

    public func json(_ request: URLRequest, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return data(request, completion: { (data, response, error) in
            guard let data = data, data.count > 0 else {
                completion(nil, response, error)
                return
            }
            do {
                let jsonObject = try self.json(data, options: options)
                completion(jsonObject, response, error)
            } catch {
                completion(nil, response, self.netError(error))
            }
        })
    }

    public func json(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return json(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options, completion: completion)
    }

    public func json(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, NetResponse?, NetError?) -> Swift.Void) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return json(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options, completion: completion)
    }

}
