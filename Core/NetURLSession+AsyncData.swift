//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 17/3/17.
//
//

public extension NetURLSession {

    public func data(_ request: URLRequest, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.dataTask(with: request)
            task.resume()
            return task
        }
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }

    public func data(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        return data(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func data(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
