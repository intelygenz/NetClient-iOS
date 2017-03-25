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

    public let response: NetResponse?

    public var description: String?

    public var state: NetState

    public let error: NetError?

    public var priority: Float?

    public var progress: Progress?

    public var metrics: NetTaskMetrics?

    fileprivate let task: NetTaskProtocol?

    public init(_ identifier: NetTaskIdentifier? = nil, request: NetRequest? = nil , response: NetResponse? = nil, description: String? = nil, state: NetState, error: NetError? = nil, priority: Float? = nil, progress: Progress? = nil, metrics: NetTaskMetrics? = nil, task: NetTaskProtocol? = nil) {
        self.request = request
        self.identifier = identifier ?? NetTaskIdentifier(arc4random())
        self.response = response
        self.description = description
        self.state = state
        self.error = error
        self.priority = priority
        self.progress = progress
        self.task = task
    }

}

extension NetTask: NetTaskProtocol {

    public func cancel() {
        task?.cancel()
        state = .canceling
    }

    public func suspend() {
        task?.suspend()
        state = .suspended
    }

    public func resume() {
        task?.resume()
        state = .running
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
