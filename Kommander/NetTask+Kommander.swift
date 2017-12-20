//
//  NetTask+Kommander.swift
//  Net
//
//  Created by Alex Rupérez on 17/8/17.
//
//

import Kommander

extension NetTask {

    /// Execute NetTask
    @discardableResult open func execute<T>(by kommander: Kommander, after delay: DispatchTimeInterval? = nil, onSuccess: ((_ result: T) -> Void)?, onError: ((_ error: Error?) -> Void)?) -> Kommand<T> {
        let kommand = kommander.makeKommand {
            return try self.sync().object()
        }.onSuccess { result in
            onSuccess?(result)
        }.onError { error in
            onError?(error)
        }
        if let delay = delay {
            kommand.execute(after: delay)
        } else {
            kommand.execute()
        }
        return kommand
    }

    /// Execute NetTask decoding the result
    @discardableResult open func executeDecoding<D: Decodable>(by kommander: Kommander, after delay: DispatchTimeInterval? = nil, onSuccess: ((_ result: D) -> Void)?, onError: ((_ error: Error?) -> Void)?) -> Kommand<D> {
        let kommand = kommander.makeKommand {
            return try self.sync().decode()
            }.onSuccess { result in
                onSuccess?(result)
            }.onError { error in
                onError?(error)
        }
        if let delay = delay {
            kommand.execute(after: delay)
        } else {
            kommand.execute()
        }
        return kommand
    }

}
