//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 17/3/17.
//
//

public extension NetURLSession {

    public func upload(_ streamedRequest: URLRequest) -> URLSessionTask {
        let task = session.uploadTask(withStreamedRequest: streamedRequest)
        task.resume()
        return task
    }

    public func upload(_ streamedURL: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> URLSessionTask {
        return upload(urlRequest(streamedURL, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func upload(_ streamedURLString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> URLSessionTask {
        guard let url = URL(string: streamedURLString) else {
            throw URLError(.badURL)
        }
        return upload(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

    public func upload(_ request: URLRequest, data: Data, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.uploadTask(with: request, from: data)
            task.resume()
            return task
        }
        let task = session.uploadTask(with: request, from: data, completionHandler: completion)
        task.resume()
        return task
    }

    public func upload(_ url: URL, data: Data, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        return upload(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), data: data, completion: completion)
    }

    public func upload(_ urlString: String, data: Data, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return upload(url, data: data, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

    public func upload(_ request: URLRequest, fileURL: URL, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.uploadTask(with: request, fromFile: fileURL)
            task.resume()
            return task
        }
        let task = session.uploadTask(with: request, fromFile: fileURL, completionHandler: completion)
        task.resume()
        return task
    }

    public func upload(_ url: URL, fileURL: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        return upload(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), fileURL: fileURL, completion: completion)
    }

    public func upload(_ urlString: String, fileURL: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return upload(url, fileURL: fileURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
