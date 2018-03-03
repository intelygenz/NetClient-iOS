//
//  NetAlamofire.swift
//  Net
//
//  Created by Alex Rupérez on 24/4/17.
//
//

import Alamofire

open class NetAlamofire: Net {

    open static let shared: Net = NetAlamofire(URLSession.shared)!

    open static let defaultCache: URLCache = {
        let defaultMemoryCapacity = 4 * 1024 * 1024
        let defaultDiskCapacity = 5 * defaultMemoryCapacity
        let cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let cacheURL = cachesDirectoryURL?.appendingPathComponent(String(describing: NetAlamofire.self))
        var defaultDiskPath = cacheURL?.path
        #if os(OSX)
            defaultDiskPath = cacheURL?.absoluteString
        #endif
        return URLCache(memoryCapacity: defaultMemoryCapacity, diskCapacity: defaultDiskCapacity, diskPath: defaultDiskPath)
    }()

    private var requestInterceptors = [InterceptorToken: RequestInterceptor]()

    private var responseInterceptors = [InterceptorToken: ResponseInterceptor]()

    open var retryClosure: NetTask.RetryClosure? {
        didSet {
            sessionManager.retrier = self
        }
    }

    open var acceptableStatusCodes = defaultAcceptableStatusCodes

    open private(set) var sessionManager: Alamofire.SessionManager!

    open var authChallenge: ((URLAuthenticationChallenge, (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) -> Swift.Void)? {
        didSet {
            sessionManager.delegate.sessionDidReceiveChallengeWithCompletion = { session, challenge, completion in
                self.authChallenge?(challenge, completion)
            }
        }
    }

    let queue: DispatchQueue

    public convenience init() {
        let defaultConfiguration = URLSessionConfiguration.default
        defaultConfiguration.urlCache = NetAlamofire.defaultCache
        self.init(defaultConfiguration)
    }

    public init(_ configuration: URLSessionConfiguration, delegate: Alamofire.SessionDelegate = Alamofire.SessionDelegate(), serverTrustPolicyManager: Alamofire.ServerTrustPolicyManager? = nil, queue: DispatchQueue = .global(qos: .default)) {
        self.sessionManager = Alamofire.SessionManager(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
        self.queue = queue
    }

    public init?(_ session: URLSession, delegate: Alamofire.SessionDelegate = Alamofire.SessionDelegate(), serverTrustPolicyManager: Alamofire.ServerTrustPolicyManager? = nil, queue: DispatchQueue = .global(qos: .default)) {
        guard let sessionManager = Alamofire.SessionManager(session: session, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager) else {
            return nil
        }
        self.sessionManager = sessionManager
        self.queue = queue
    }

    deinit {
        authChallenge = nil
        retryClosure = nil
        sessionManager = nil
    }

    @discardableResult open func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor) -> InterceptorToken {
        let token = InterceptorToken()
        requestInterceptors[token] = interceptor
        return token
    }

    @discardableResult open func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor) -> InterceptorToken {
        let token = InterceptorToken()
        responseInterceptors[token] = interceptor
        return token
    }

    @discardableResult open func removeInterceptor(_ token: InterceptorToken) -> Bool {
        guard requestInterceptors.removeValue(forKey: token) != nil else {
            return responseInterceptors.removeValue(forKey: token) != nil
        }
        return true
    }

}

extension NetAlamofire {

    func urlRequest(_ netRequest: NetRequest) -> URLRequest {
        var builder = netRequest.builder()
        requestInterceptors.values.forEach { interceptor in
            builder = interceptor(builder)
        }
        return builder.build().urlRequest
    }

    func netRequest(_ url: URL, cache: NetRequest.NetCachePolicy? = nil, timeout: TimeInterval? = nil) -> NetRequest {
        let cache = cache ?? NetRequest.NetCachePolicy(rawValue: sessionManager.session.configuration.requestCachePolicy.rawValue) ?? .useProtocolCachePolicy
        let timeout = timeout ?? sessionManager.session.configuration.timeoutIntervalForRequest
        return NetRequest(url, cache: cache, timeout: timeout)
    }

    func netTask(_ alamofireRequest: Alamofire.Request, _ request: NetRequest? = nil) -> NetTask? {
        return NetTask(alamofireRequest, request: request)
    }

    func netResponse(_ response: URLResponse?, _ netTask: NetTask? = nil, _ responseObject: Any? = nil) -> NetResponse? {
        var netResponse: NetResponse?
        if let httpResponse = response as? HTTPURLResponse {
            netResponse = NetResponse(httpResponse, netTask, responseObject)
        } else if let response = response {
            netResponse = NetResponse(response, netTask, responseObject)
        }
        guard let response = netResponse else {
            return nil
        }
        var builder = response.builder()
        responseInterceptors.values.forEach { interceptor in
            builder = interceptor(builder)
        }
        return builder.build()
    }

    func netError(_ error: Error?, _ responseObject: Any? = nil, _ response: URLResponse? = nil) -> NetError? {
        if let error = error {
            return .net(code: error._code, message: error.localizedDescription, headers: (response as? HTTPURLResponse)?.allHeaderFields, object: responseObject, underlying: error)
        }
        return nil
    }
    
}

extension NetAlamofire: RequestRetrier {

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        completion(retryClosure?(netResponse(request.response), netError(error), request.retryCount) == true, 0)
    }

}
