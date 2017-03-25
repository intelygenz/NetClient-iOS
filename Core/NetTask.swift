//
//  NetTask.swift
//  Net
//
//  Created by Alex Rupérez on 25/3/17.
//
//

import Foundation

public typealias NetTaskIdentifier = Int

public protocol NetTaskProtocol: class {

    func cancel()

    func suspend()

    func resume()

}

public class NetTask {

    public enum NetState : Int {
        case running, suspended, canceling, completed
    }

    public let identifier: NetTaskIdentifier

    public let request: NetRequest?

    public internal(set) var response: NetResponse?

    public let description: String?

    public internal(set) var state: NetState

    public internal(set) var error: NetError?

    public let priority: Float?

    public internal(set) var progress: Progress?

    public internal(set) var metrics: NetTaskMetrics?

    fileprivate let task: NetTaskProtocol?

    public init(_ identifier: NetTaskIdentifier? = nil, request: NetRequest? = nil , response: NetResponse? = nil, description: String? = nil, state: NetState, error: NetError? = nil, priority: Float? = nil, progress: Progress? = nil, metrics: NetTaskMetrics? = nil, task: NetTaskProtocol? = nil) {
        self.request = request
        self.identifier = identifier ?? NetTaskIdentifier(arc4random())
        self.response = response
        self.description = description ?? request?.description
        self.state = state
        self.error = error
        self.priority = priority
        self.progress = progress
        self.task = task
    }

}

extension NetTask: NetTaskProtocol {

    public func cancel() {
        state = .canceling
        task?.cancel()
    }

    public func suspend() {
        state = .suspended
        task?.suspend()
    }

    public func resume() {
        state = .running
        task?.resume()
    }

}

extension NetTask: Hashable {

    public var hashValue: Int {
        return identifier.hashValue
    }
    
}

extension NetTask: Equatable {

    public static func ==(lhs: NetTask, rhs: NetTask) -> Bool {
        return lhs.identifier == rhs.identifier
    }

}
