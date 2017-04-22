//
//  Net.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public protocol Net: class {

    typealias RequestInterceptor = (NetRequest.Builder) -> NetRequest.Builder

    typealias ResponseInterceptor = (NetResponse.Builder) -> NetResponse.Builder

    static var shared: Net { get }

    var requestInterceptors: [RequestInterceptor] { get set }

    var responseInterceptors: [ResponseInterceptor] { get set }

    func addRequestInterceptor(_ interceptor: @escaping RequestInterceptor)

    func addResponseInterceptor(_ interceptor: @escaping ResponseInterceptor)

    func data(_ request: NetRequest) -> NetTask

    func download(_ resumeData: Data) -> NetTask

    func download(_ request: NetRequest) -> NetTask

    func upload(_ streamedRequest: NetRequest) -> NetTask

    func upload(_ request: NetRequest, data: Data) -> NetTask

    func upload(_ request: NetRequest, fileURL: URL) -> NetTask

    @available(iOS 9.0, OSX 10.11, *)
    func stream(_ netService: NetService) -> NetTask

    @available(iOS 9.0, OSX 10.11, *)
    func stream(_ domain: String, type: String, name: String, port: Int32?) -> NetTask

    @available(iOS 9.0, OSX 10.11, *)
    func stream(_ hostName: String, port: Int) -> NetTask

}
