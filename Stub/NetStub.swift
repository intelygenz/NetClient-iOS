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
    
    open static var shared: Net = NetStub()

    private var requestInterceptors = [InterceptorToken: RequestInterceptor]()

    private var responseInterceptors = [InterceptorToken: ResponseInterceptor]()

    open var retryClosure: NetTask.RetryClosure?

    open var nextResult: Result?

    public init(_ nextResult: Result? = nil) {
        self.nextResult = nextResult
    }

    open func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor) -> InterceptorToken {
        let token = InterceptorToken()
        requestInterceptors[token] = interceptor
        return token
    }

    open func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor) -> InterceptorToken {
        let token = InterceptorToken()
        responseInterceptors[token] = interceptor
        return token
    }

    open func removeInterceptor(_ token: InterceptorToken) -> Bool {
        var removed = requestInterceptors.removeValue(forKey: token) != nil
        removed = responseInterceptors.removeValue(forKey: token) != nil || removed
        return removed
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
            return NetTaskStub(request: requestBuilder?.build())
        }
        switch nextResult {
        case .response(let response):
            var responseBuilder = response.builder()
            responseInterceptors.values.forEach { interceptor in
                responseBuilder = interceptor(responseBuilder)
            }
            return NetTaskStub(request: requestBuilder?.build(), response: responseBuilder.build())
        case .error(let error):
            var retryCount: UInt = 0
            while retryClosure?(nil, error, retryCount) == true {
                retryCount += 1
            }
            let netTask = NetTaskStub(request: requestBuilder?.build(), error: error)
            netTask.retryCount = retryCount
            return netTask
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
