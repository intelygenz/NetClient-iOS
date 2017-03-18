//
//  NetURLSessionTaskObserver.swift
//  Net
//
//  Created by Alex Rupérez on 18/3/17.
//
//

import Foundation

class NetURLSessionTaskObserver: NSObject {

    private enum ObservedValue: String {
        case countOfBytesReceived,
             countOfBytesSent,
             countOfBytesExpectedToSend,
             countOfBytesExpectedToReceive,
             state
    }

    var progress = [NetURLSessionTaskIdentifier: Progress]()

    func add(_ task: URLSessionTask) {
        for observedValue in iterateEnum(ObservedValue.self) {
            task.addObserver(self, forKeyPath: observedValue.rawValue, options: .new, context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let task = object as? URLSessionTask, let newValue = change?[.newKey] else {
            return
        }
        if let state = newValue as? Int, ObservedValue(rawValue: keyPath) == .state, URLSessionTask.State(rawValue: state) != .running {
            progress[task.taskIdentifier] = nil
            for observedValue in iterateEnum(ObservedValue.self) {
                task.removeObserver(self, forKeyPath: observedValue.rawValue, context: context)
            }
            return
        }
        if progress[task.taskIdentifier] == nil {
            progress[task.taskIdentifier] = Progress(totalUnitCount: max(task.countOfBytesExpectedToReceive, task.countOfBytesExpectedToSend))
        }
        progress[task.taskIdentifier]?.completedUnitCount = max(task.countOfBytesReceived, task.countOfBytesSent)
    }

    private func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }

}
