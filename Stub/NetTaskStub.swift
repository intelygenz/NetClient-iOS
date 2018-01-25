//
//  NetTaskStub.swift
//  Net
//
//  Created by Alex Rupérez on 24/1/18.
//

import Foundation

class NetTaskStub: NetTask {

    override func async(_ completion: NetTask.CompletionClosure?) -> Self {
        completionClosure = completion
        progressClosure?(Progress(totalUnitCount: 0))
        completion?(response, error)
        return self
    }

    override func sync() throws -> NetResponse {
        guard let response = response else {
            throw error ?? .net(code: nil, message: "Next result not specified.", headers: nil, object: nil, underlying: nil)
        }
        progressClosure?(Progress(totalUnitCount: 0))
        return response
    }

    override func cached() throws -> NetResponse {
        guard let response = response else {
            throw error ?? .net(code: nil, message: "Next result not specified.", headers: nil, object: nil, underlying: nil)
        }
        return response
    }

}
