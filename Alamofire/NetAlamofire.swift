//
//  NetAlamofire.swift
//  Net
//
//  Created by Alex Rupérez on 24/4/17.
//
//

import Alamofire

public class NetAlamofire: Net {

    open static let shared: Net = NetAlamofire()

    open var requestInterceptors = [RequestInterceptor]()

    open var responseInterceptors = [ResponseInterceptor]()

    open func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor) {
        requestInterceptors.append(interceptor)
    }

    open func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor) {
        responseInterceptors.append(interceptor)
    }

    open func data(_ request: NetRequest) -> NetTask {
        return NetTask()
    }

    open func download(_ resumeData: Data) -> NetTask {
        return NetTask()
    }

    open func download(_ request: NetRequest) -> NetTask {
        return NetTask()
    }

    open func upload(_ streamedRequest: NetRequest) -> NetTask {
        return NetTask()
    }

    open func upload(_ request: NetRequest, data: Data) -> NetTask {
        return NetTask()
    }

    open func upload(_ request: NetRequest, fileURL: URL) -> NetTask {
        return NetTask()
    }

    #if !os(watchOS)
    @available(iOS 9.0, OSX 10.11, *)
    open func stream(_ netService: NetService) -> NetTask {
        return NetTask()
    }

    @available(iOS 9.0, OSX 10.11, *)
    open func stream(_ domain: String, type: String, name: String, port: Int32?) -> NetTask {
        return NetTask()
    }

    @available(iOS 9.0, OSX 10.11, *)
    open func stream(_ hostName: String, port: Int) -> NetTask {
        return NetTask()
    }
    #endif
}
