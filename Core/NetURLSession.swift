//
//  NetURLSession.swift
//  Net
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import Foundation

open class NetURLSession: Net {

    public typealias RequestInterceptor = (NetRequest.Builder) -> NetRequest.Builder

    public typealias ResponseInterceptor = (NetResponse.Builder) -> NetResponse.Builder

    open static let shared = NetURLSession(URLSession.shared)

    open private(set) var session: URLSession!

    open var delegate: URLSessionDelegate? { return session.delegate }

    open var delegateQueue: OperationQueue { return session.delegateQueue }

    open var configuration: URLSessionConfiguration { return session.configuration }

    open var sessionDescription: String? {
        get {
            return session.sessionDescription
        }
        set {
            session.sessionDescription = newValue
        }
    }

    open var requestInterceptors = [RequestInterceptor]()

    open var responseInterceptors = [ResponseInterceptor]()

    open private(set) var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) -> Swift.Void)?

    fileprivate final var taskObserver: NetURLSessionTaskObserver? = NetURLSessionTaskObserver()

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

    public init(_ configuration: URLSessionConfiguration, challengeQueue: OperationQueue? = nil, authenticationChallenge: @escaping @autoclosure (URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) -> Swift.Void) {
        session = URLSession(configuration: configuration, delegate: NetURLSessionDelegate(self), delegateQueue: challengeQueue)
        authChallenge = authenticationChallenge
    }

    public func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor) {
        requestInterceptors.append(interceptor)
    }

    public func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }

    deinit {
        taskObserver = nil
        authChallenge = nil
        session.invalidateAndCancel()
        session = nil
    }
    
}

extension NetURLSession {

    func observe(_ task: URLSessionTask, _ netTask: NetTask) {
        taskObserver?.add(task, netTask)
        if let delegate = delegate as? NetURLSessionDelegate {
            delegate.add(task, netTask)
        }
    }

    func urlRequest(_ netRequest: NetRequest) -> URLRequest {
        var builder = netRequest.builder()
        requestInterceptors.forEach({ interceptor in
            builder = interceptor(builder)
        })
        return builder.build().urlRequest
    }

    func netRequest(_ url: URL, cache: NetRequest.NetCachePolicy? = nil, timeout: TimeInterval? = nil) -> NetRequest {
        let cache = cache ?? NetRequest.NetCachePolicy(rawValue: session.configuration.requestCachePolicy.rawValue) ?? .useProtocolCachePolicy
        let timeout = timeout ?? session.configuration.timeoutIntervalForRequest
        return NetRequest(url, cache: cache, timeout: timeout)
    }

    func netTask(_ urlSessionTask: URLSessionTask, _ request: NetRequest? = nil) -> NetTask {
        if let currentRequest = urlSessionTask.currentRequest {
            return NetTask(urlSessionTask, request: currentRequest.netRequest)
        } else if let originalRequest = urlSessionTask.originalRequest {
            return NetTask(urlSessionTask, request: originalRequest.netRequest)
        }
        return NetTask(urlSessionTask, request: request)
    }

    func netResponse(_ response: URLResponse?, _ responseObject: Any? = nil) -> NetResponse? {
        var netResponse: NetResponse?
        if let httpResponse = response as? HTTPURLResponse {
            netResponse = NetResponse(httpResponse, responseObject)
        } else if let response = response {
            netResponse = NetResponse(response, responseObject)
        }
        guard let response = netResponse else {
            return nil
        }
        var builder = response.builder()
        responseInterceptors.forEach({ interceptor in
            builder = interceptor(builder)
        })
        return builder.build()
    }

    func netError(_ error: Error?) -> NetError? {
        if let error = error {
            return NetError.error(code: error._code, message: error.localizedDescription, underlying: error)
        }
        return nil
    }

}
