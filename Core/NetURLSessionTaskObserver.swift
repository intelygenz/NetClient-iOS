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

    deinit {
        for taskProgress in progress.values {
            if taskProgress == Progress.current() {
                taskProgress.resignCurrent()
            }
            taskProgress.cancel()
        }
        progress.removeAll()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, let task = object as? URLSessionTask, let newValue = change?[.newKey] else {
            return
        }
        var taskProgress = progress[task.taskIdentifier]
        if ObservedKeyPath(rawValue: keyPath) == .state, let intValue = newValue as? Int, let state = URLSessionTask.State(rawValue: intValue) {
            if state != .running {
                if taskProgress == Progress.current() {
                    taskProgress?.resignCurrent()
                }
                if state == .suspended {
                    taskProgress?.pause()
                } else {
                    if state == .canceling {
                        taskProgress?.cancel()
                    }
                    if taskProgress != nil {
                        for observedValue in ObservedKeyPath.all {
                            task.removeObserver(self, forKeyPath: observedValue.rawValue, context: context)
                        }
                    }
                    progress[task.taskIdentifier] = nil
                    return
                }
            } else {
                if #available(iOSApplicationExtension 9.0, *) {
                    if taskProgress?.isPaused == true {
                        taskProgress?.resume()
                    }
                }
            }
        }
        let completedUnitCount = max(task.countOfBytesReceived, task.countOfBytesSent)
        let totalUnitCount = max(task.countOfBytesExpectedToReceive, task.countOfBytesExpectedToSend)
        if taskProgress == nil {
            taskProgress = syncProgress(task, totalUnitCount: totalUnitCount)
            progress[task.taskIdentifier] = taskProgress
            taskProgress?.becomeCurrent(withPendingUnitCount: totalUnitCount)
        }
        taskProgress?.completedUnitCount = completedUnitCount
        taskProgress?.totalUnitCount = totalUnitCount
    }

}

fileprivate extension NetURLSessionTaskObserver {

    func syncProgress(_ task: URLSessionTask, totalUnitCount: Int64) -> Progress {
        let taskProgress = Progress(totalUnitCount: totalUnitCount)
        taskProgress.isPausable = true
        taskProgress.isCancellable = true
        taskProgress.pausingHandler = { [weak task] in
            if task?.state != .suspended {
                task?.suspend()
            }
        }
        taskProgress.cancellationHandler = { [weak task] in
            if task?.state != .canceling {
                task?.cancel()
            }
        }
        if #available(iOSApplicationExtension 9.0, *) {
            taskProgress.resumingHandler = { [weak task] in
                if task?.state != .running {
                    task?.resume()
                }
            }
        }
        return taskProgress
    }

}
