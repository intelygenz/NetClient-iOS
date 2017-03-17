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

    var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void)?

    public init() {}

    public init(configuration: URLSessionConfiguration, delegate: URLSessionDelegate? = nil, delegateQueue: OperationQueue? = OperationQueue.current) {
        let sessionDelegate = delegate ?? NetURLSessionDelegate(self)
        session = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: delegateQueue)
    }

    public init(configuration: URLSessionConfiguration, challengeQueue: OperationQueue? = OperationQueue.current, authenticationChallenge: @escaping (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) -> Void) {
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
