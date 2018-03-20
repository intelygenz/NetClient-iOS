//
//  NetTaskStub.swift
//  Net
//
//  Created by Alex Rupérez on 24/1/18.
//

import Foundation

class NetTaskStub: NetTask {

    var queue: DispatchQueue?
    var delay: DispatchTimeInterval?

    init(request: NetRequest? = nil, response: NetResponse? = nil, error: NetError? = nil, retryCount: UInt = 0, queue: DispatchQueue? = nil, delay: DispatchTimeInterval? = nil) {
        super.init(request: request, response: response, error: error)
        self.retryCount = retryCount
        self.queue = queue
        self.delay = delay
    }

    override func async(_ completion: NetTask.CompletionClosure?) -> Self {
        completionClosure = completion
        progressClosure?(Progress(totalUnitCount: 0))
        if let delay = delay {
            (queue ?? .main).asyncAfter(deadline: .now() + delay) {
                self.handleNextResult(completion)
            }
        } else if let queue = queue {
            queue.async {
                self.handleNextResult(completion)
            }
        } else {
            handleNextResult(completion)
        }
        return self
    }

    override func sync() throws -> NetResponse {
        let response = try nextResult()
        progressClosure?(Progress(totalUnitCount: 0))
        return response
    }

    override func cached() throws -> NetResponse {
        return try nextResult()
    }

    private func nextResult() throws -> NetResponse {
        guard let response = response else {
            throw error ?? .net(code: nil, message: "Next result not specified.", headers: nil, object: nil, underlying: nil)
        }
        return response
    }

    private func handleNextResult(_ completion: NetTask.CompletionClosure?) {
        do {
            completion?(try nextResult(), error)
        } catch {
            completion?(response, error as? NetError)
        }
    }

}
