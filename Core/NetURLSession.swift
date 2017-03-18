//
//  NetURLSession.swift
//  Net
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import Foundation

public typealias NetURLSessionTaskIdentifier = Int

open class NetURLSession {

    open static let shared = NetURLSession(URLSession.shared)

    open private(set) var session: URLSession!

    open var delegate: URLSessionDelegate? { return session.delegate }

    open var delegateQueue: OperationQueue { return session.delegateQueue }

    open var configuration: URLSessionConfiguration { return session.configuration }

    open var sessionDescription: String? { return session.sessionDescription }

    open private(set) var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    open var progress: [NetURLSessionTaskIdentifier: Progress] {
        return taskObserver.progress
    }

    @available(iOSApplicationExtension 10.0, *)
    open var metrics: [NetURLSessionTaskIdentifier: URLSessionTaskMetrics] {
        guard let delegate = delegate as? NetURLSessionDelegate, let metrics = delegate.metrics as? [NetURLSessionTaskIdentifier: URLSessionTaskMetrics] else {
            return [:]
        }
        return metrics
    }

    fileprivate let taskObserver = NetURLSessionTaskObserver()

    public convenience init() {
        self.init(.default)
    }

    public init(_ urlSession: URLSession) {
        session = urlSession
    }

    public init(_ configuration: URLSessionConfiguration, delegateQueue: OperationQueue? = nil, delegate: URLSessionDelegate? = nil) {
        let sessionDelegate = delegate ?? NetURLSessionDelegate(self)
        session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: delegateQueue)
    }

    public init(_ configuration: URLSessionConfiguration, challengeQueue: OperationQueue? = nil, authenticationChallenge: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) {
        session = URLSession(configuration: configuration, delegate: NetURLSessionDelegate(self), delegateQueue: challengeQueue)
        authChallenge = authenticationChallenge
    }
    
}

public extension NetURLSession {

    func progress(_ task: URLSessionTask) -> Progress? {
        return progress[task.taskIdentifier]
    }

    @available(iOSApplicationExtension 10.0, *)
    func metrics(_ task: URLSessionTask) -> URLSessionTaskMetrics? {
        return metrics[task.taskIdentifier]
    }

}

extension NetURLSession {

    func urlRequest(_ url: URL, cache: URLRequest.CachePolicy? = nil, timeout: TimeInterval? = nil) -> URLRequest {
        let cache = cache ?? session.configuration.requestCachePolicy
        let timeout = timeout ?? session.configuration.timeoutIntervalForRequest
        return URLRequest(url: url, cachePolicy: cache, timeoutInterval: timeout)
    }

    func json(_ data: Data, options: JSONSerialization.ReadingOptions = .allowFragments) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: options)
    }

    func observe(_ task: URLSessionTask) {
        taskObserver.add(task)
    }

}
