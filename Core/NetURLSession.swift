//
//  NetURLSession.swift
//  Net
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import Foundation

public typealias NetURLSessionTaskIdentifier = Int

open class NetURLSession: Net {

    open static let shared = NetURLSession(URLSession.shared)

    open private(set) var session: URLSession!

    open var delegate: URLSessionDelegate? { return session.delegate }

    open var delegateQueue: OperationQueue { return session.delegateQueue }

    open var configuration: URLSessionConfiguration { return session.configuration }

    open var sessionDescription: String? { return session.sessionDescription }

    open private(set) var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    open var progress: [NetURLSessionTaskIdentifier: Progress] {
        guard let progress = taskObserver?.progress else {
            return [:]
        }
        return progress
    }

    @available(iOSApplicationExtension 10.0, *)
    open var metrics: [NetURLSessionTaskIdentifier: URLSessionTaskMetrics] {
        guard let delegate = delegate as? NetURLSessionDelegate, let metrics = delegate.metrics as? [NetURLSessionTaskIdentifier: URLSessionTaskMetrics] else {
            return [:]
        }
        return metrics
    }

    fileprivate var taskObserver: NetURLSessionTaskObserver? = NetURLSessionTaskObserver()

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

    deinit {
        taskObserver = nil
        authChallenge = nil
        session.invalidateAndCancel()
        session = nil
    }
    
}

public extension NetURLSession {

    public func progress(_ task: URLSessionTask) -> Progress? {
        return progress[task.taskIdentifier]
    }

    @available(iOSApplicationExtension 10.0, *)
    public func metrics(_ task: URLSessionTask) -> URLSessionTaskMetrics? {
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

    func string(_ data: Data, encoding: String.Encoding = .utf8) -> String? {
        return String(data: data, encoding: encoding)
    }

    func observe(_ task: URLSessionTask) {
        taskObserver?.add(task)
    }

    func netResponse(_ response: URLResponse?) -> NetResponse? {
        if let httpResponse = response as? HTTPURLResponse {
            return NetResponse(httpResponse)
        } else if let response = response {
            return NetResponse(response)
        }
        return nil
    }

    func netError(_ error: Error?) -> NetError? {
        if let error = error as? NSError {
            return NetError.error(code: error.code, message: error.localizedDescription, underlying: error)
        } else if let error = error {
            return NetError.error(code: nil, message: error.localizedDescription, underlying: error)
        }
        return nil
    }

}
