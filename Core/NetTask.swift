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

    public let taskDescription: String?

    public internal(set) var state: NetState

    public internal(set) var error: NetError?

    public let priority: Float?

    public internal(set) var progress: Progress?

    public internal(set) var metrics: NetTaskMetrics?

    fileprivate let task: NetTaskProtocol?

    fileprivate(set) var dispatchSemaphore: DispatchSemaphore?

    fileprivate(set) var completionClosure: CompletionClosure?

    public init(_ identifier: NetTaskIdentifier? = nil, request: NetRequest? = nil , response: NetResponse? = nil, taskDescription: String? = nil, state: NetState = .suspended, error: NetError? = nil, priority: Float? = nil, progress: Progress? = nil, metrics: NetTaskMetrics? = nil, task: NetTaskProtocol? = nil) {
        self.request = request
        self.identifier = identifier ?? NetTaskIdentifier(arc4random())
        self.response = response
        self.taskDescription = taskDescription ?? request?.description
        self.state = state
        self.error = error
        self.priority = priority
        self.progress = progress
        self.task = task
    }

}

extension NetTask {

    public typealias CompletionClosure = (NetResponse?, NetError?) -> Swift.Void

    @discardableResult public func async(_ completion: CompletionClosure? = nil) -> Self {
        completionClosure = completion
        resume()
        return self
    }

    public func sync() throws -> NetResponse {
        dispatchSemaphore = DispatchSemaphore(value: 0)
        resume()
        let dispatchTimeoutResult = dispatchSemaphore?.wait(timeout: DispatchTime.distantFuture)
        if dispatchTimeoutResult == .timedOut {
            let urlError = URLError(.timedOut)
            error = NetError.error(code: urlError._code, message: urlError.localizedDescription, underlying: urlError)
        }
        if let error = error {
            throw error
        }
        return response!
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

extension NetTask: CustomStringConvertible {

    public var description: String {
        var description = String(describing: NetTask.self) + " " + identifier.description + " (" + String(describing: state) + ")"
        if let taskDescription = taskDescription {
            description = description + " " + taskDescription
        }
        return description
    }

}

extension NetTask: CustomDebugStringConvertible {

    public var debugDescription: String {
        return description
    }
    
}
