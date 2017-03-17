//
//  NetURLSession.swift
//  Net
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import Foundation

open class NetURLSession {

    open class var shared: NetURLSession { return NetURLSession() }

    open private(set) var session = URLSession.shared

    open var delegateQueue: OperationQueue { return session.delegateQueue }

    open var delegate: URLSessionDelegate? { return session.delegate }

    open var configuration: URLSessionConfiguration { return session.configuration }

    open var sessionDescription: String? { return session.sessionDescription }

    public init() {}

    public init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate? = nil, delegateQueue: OperationQueue? = OperationQueue.current) {
        session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: delegateQueue)
    }

    open func task(_ request: URLRequest, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            return session.dataTask(with: request)
        }
        return session.dataTask(with: request, completionHandler: completion)
    }

    open func task(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        return task(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    open func task(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, URLResponse?, Error?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return task(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

    open func json(_ request: URLRequest, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) -> URLSessionTask {
        return task(request, completion: { (data, response, error) in
            guard let data = data else {
                completion(nil, response, error)
                return
            }
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: options)
                completion(jsonObject, response, error)
            } catch {
                completion(nil, response, error)
            }
        })
    }

    open func json(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) -> URLSessionTask {
        return json(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options, completion: completion)
    }

    open func json(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments, completion: @escaping (Any?, URLResponse?, Error?) -> Swift.Void) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return json(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options, completion: completion)
    }

    open func json(_ request: URLRequest, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        var jsonObject: Any?
        var jsonError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        let task = json(request, options: options, completion: { (data, response, error) in
            jsonObject = data
            jsonError = error
            dispatchSemaphore.signal()
        })
        task.resume()
        dispatchSemaphore.wait()
        if let jsonError = jsonError {
            throw jsonError
        }
        return jsonObject
    }

    open func json(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        do {
            return try json(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), options: options)
        } catch {
            throw error
        }
    }

    open func json(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        do {
            return try json(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, options: options)
        } catch {
            throw error
        }
    }

    private func urlRequest(_ url: URL, cache: URLRequest.CachePolicy? = nil, timeout: TimeInterval? = nil) -> URLRequest {
        let cache = cache ?? session.configuration.requestCachePolicy
        let timeout = timeout ?? session.configuration.timeoutIntervalForRequest
        return URLRequest(url: url, cachePolicy: cache, timeoutInterval: timeout)
    }
    
}
