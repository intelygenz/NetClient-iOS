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

    open var requestInterceptors = [RequestInterceptor]()

    open var responseInterceptors = [ResponseInterceptor]()

    open var retryClosure: NetTask.RetryClosure?

    open var nextResult: Result?

    public init(_ nextResult: Result? = nil) {
        self.nextResult = nextResult
    }

    open func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor) {
        requestInterceptors.append(interceptor)
    }

    open func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }

    private func stub(_ request: NetRequest? = nil) -> NetTask {
        var requestBuilder = request?.builder()
        if let builder = requestBuilder {
            requestInterceptors.forEach { interceptor in
                requestBuilder = interceptor(builder)
            }
        }
        guard let nextResult = nextResult else {
            return NetTaskStub(request: requestBuilder?.build())
        }
        switch nextResult {
        case .response(let response):
            var responseBuilder = response.builder()
            responseInterceptors.forEach { interceptor in
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

    open func stream(_ netService: NetService) -> NetTask {
        return stub()
    }

    open func stream(_ domain: String, type: String, name: String, port: Int32?) -> NetTask {
        return stub()
    }

    open func stream(_ hostName: String, port: Int) -> NetTask {
        return stub()
    }

}
