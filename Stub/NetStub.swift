//
//  NetStub.swift
//  Net
//
//  Created by Alex Rupérez on 24/1/18.
//

import Foundation

open class NetStub: Net {

    public enum Result {
        case response(NetResponse), error(NetError)
    }

    public enum AsyncBehavior: Equatable {
        case immediate(DispatchQueue?), delayed(DispatchQueue?, DispatchTimeInterval)
    }
    
    public static var shared: Net = NetStub()

    var requestInterceptors = [InterceptorToken: RequestInterceptor]()

    var responseInterceptors = [InterceptorToken: ResponseInterceptor]()

    open var retryClosure: NetTask.RetryClosure?

    open var acceptableStatusCodes = defaultAcceptableStatusCodes

    open var nextResult: Result?

    open var asyncBehavior: AsyncBehavior

    public init(_ nextResult: Result? = nil, _ asyncBehavior: AsyncBehavior = .immediate(nil)) {
        self.nextResult = nextResult
        self.asyncBehavior = asyncBehavior
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

    func stub(_ request: NetRequest? = nil) -> NetTask {
        var requestBuilder = request?.builder()
        if var builder = requestBuilder {
            requestInterceptors.values.forEach { interceptor in
                builder = interceptor(builder)
            }
            requestBuilder = builder
        }
        guard let nextResult = nextResult else {
            switch asyncBehavior {
            case .immediate(let queue):
                return NetTaskStub(request: requestBuilder?.build(), queue: queue)
            case .delayed(let queue, let delay):
                return NetTaskStub(request: requestBuilder?.build(), queue: queue, delay: delay)
            }
        }
        switch nextResult {
        case .response(let response):
            var responseBuilder = response.builder()
            responseInterceptors.values.forEach { interceptor in
                responseBuilder = interceptor(responseBuilder)
            }
            switch asyncBehavior {
            case .immediate(let queue):
                return NetTaskStub(request: requestBuilder?.build(), response: responseBuilder.build(), queue: queue)
            case .delayed(let queue, let delay):
                return NetTaskStub(request: requestBuilder?.build(), response: responseBuilder.build(), queue: queue, delay: delay)
            }
        case .error(let error):
            var retryCount: UInt = 0
            while retryClosure?(nil, error, retryCount) == true {
                retryCount += 1
            }
            switch asyncBehavior {
            case .immediate(let queue):
                return NetTaskStub(request: requestBuilder?.build(), error: error, retryCount: retryCount, queue: queue)
            case .delayed(let queue, let delay):
                return NetTaskStub(request: requestBuilder?.build(), error: error, retryCount: retryCount, queue: queue, delay: delay)
            }
        }
    }

    open func data(_ request: NetRequest) -> NetTask {
        return stub(request)
    }

    open func download(_ resumeData: Data) -> NetTask {
        return stub()
    }

    open func download(_ request: NetRequest) -> NetTask {
        return stub(request)
    }

    open func upload(_ streamedRequest: NetRequest) -> NetTask {
        return stub(streamedRequest)
    }

    open func upload(_ request: NetRequest, data: Data) -> NetTask {
        return stub(request)
    }

    open func upload(_ request: NetRequest, fileURL: URL) -> NetTask {
        return stub(request)
    }

    #if !os(watchOS)
    @available(iOS 9.0, macOS 10.11, *)
    open func stream(_ netService: NetService) -> NetTask {
        return stub()
    }

    @available(iOS 9.0, macOS 10.11, *)
    open func stream(_ domain: String, type: String, name: String, port: Int32?) -> NetTask {
        return stub()
    }

    @available(iOS 9.0, macOS 10.11, *)
    open func stream(_ hostName: String, port: Int) -> NetTask {
        return stub()
    }
    #endif

}
