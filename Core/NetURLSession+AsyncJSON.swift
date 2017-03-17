//
//  NetURLSession+AsyncJSON.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 17/3/17.
//
//

public extension NetURLSession {

    public func json(_ request: URLRequest, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) -> URLSessionTask {
        return data(request, completion: { (data, response, error) in
            guard let data = data else {
                completion(nil, response, error)
                return
            }
            do {
                let jsonObject = try self.json(data, options: options)
                completion(jsonObject, response, error)
            } catch {
                completion(nil, response, error)
            }
        })
    }

    public func json(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) -> URLSessionTask {
        return json(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options, completion: completion)
    }

    public func json(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return json(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options, completion: completion)
    }

}
