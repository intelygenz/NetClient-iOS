//
//  NetURLSessionTaskObserver.swift
//  Net
//
//  Created by Alex Rupérez on 18/3/17.
//
//

import Foundation

class NetURLSessionTaskObserver: NSObject {

    private enum ObservedKeyPath: String {
        case countOfBytesReceived,
             countOfBytesSent,
             countOfBytesExpectedToSend,
             countOfBytesExpectedToReceive,
             state

        static let all = [countOfBytesReceived,
                          countOfBytesSent,
                          countOfBytesExpectedToSend,
                          countOfBytesExpectedToReceive,
                          state]
    }

    var progress = [NetURLSessionTaskIdentifier: Progress]()

    func add(_ task: URLSessionTask) {
        for observedKeyPath in ObservedKeyPath.all {
            task.addObserver(self, forKeyPath: observedKeyPath.rawValue, options: .new, context: nil)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let task = object as? URLSessionTask, let newValue = change?[.newKey] else {
            return
        }
        var taskProgress = progress[task.taskIdentifier]
        if ObservedKeyPath(rawValue: keyPath) == .state, let intValue = newValue as? Int, let state = URLSessionTask.State(rawValue: intValue), state != .running {
            if taskProgress == Progress.current() {
                taskProgress?.resignCurrent()
            }
            if state == .suspended {
                taskProgress?.pause()
            } else {
                if state == .canceling {
                    taskProgress?.cancel()
                }
                progress[task.taskIdentifier] = nil
                for observedValue in ObservedKeyPath.all {
                    task.removeObserver(self, forKeyPath: observedValue.rawValue, context: context)
                }
                return
            }
        }
        let completedUnitCount = max(task.countOfBytesReceived, task.countOfBytesSent)
        let totalUnitCount = max(task.countOfBytesExpectedToReceive, task.countOfBytesExpectedToSend)
        if taskProgress == nil {
            taskProgress = Progress(totalUnitCount: totalUnitCount)
            taskProgress?.isPausable = true
            taskProgress?.isCancellable = true
            progress[task.taskIdentifier] = taskProgress
            taskProgress?.becomeCurrent(withPendingUnitCount: totalUnitCount)
        }
        taskProgress?.completedUnitCount = completedUnitCount
        taskProgress?.totalUnitCount = totalUnitCount
        if #available(iOSApplicationExtension 9.0, *) {
            if taskProgress?.isPaused == true {
                taskProgress?.resume()
            }
        }
    }

}
