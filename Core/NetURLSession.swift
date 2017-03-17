//
//  NetURLSession.swift
//  Net
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import Foundation

open class NetURLSession {

    open static let shared = NetURLSession(URLSession.shared)

    open private(set) var session: URLSession!

    open var delegateQueue: OperationQueue { return session.delegateQueue }

    open var delegate: URLSessionDelegate? { return session.delegate }

    open var configuration: URLSessionConfiguration { return session.configuration }

    open var sessionDescription: String? { return session.sessionDescription }

    var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    public convenience init() {
        self.init(.default)
    }

    public init(_ urlSession: URLSession) {
        session = urlSession
    }

    public init(_ configuration: URLSessionConfiguration, delegateQueue: OperationQueue? = OperationQueue.current, delegate: URLSessionDelegate? = nil) {
        let sessionDelegate = delegate ?? NetURLSessionDelegate(self)
        session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: delegateQueue)
    }

    public init(_ configuration: URLSessionConfiguration, challengeQueue: OperationQueue? = OperationQueue.current, authenticationChallenge: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) {
        session = URLSession(configuration: configuration, delegate: NetURLSessionDelegate(self), delegateQueue: challengeQueue)
        authChallenge = authenticationChallenge
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

}
