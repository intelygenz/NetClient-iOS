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
    @discardableResult public func execute<T>(by kommander: Kommander,
                                              after delay: DispatchTimeInterval? = nil,
                                              success: ((_ result: T) -> Void)?,
                                              error: ((_ error: Error?) -> Void)?) -> Kommand<T> {
        let kommand = kommander.make {
            return try self.sync().object()
        }.success {
            success?($0)
        }.error {
            error?($0)
        }
        if let delay = delay {
            kommand.execute(after: delay)
        } else {
            kommand.execute()
        }
        return kommand
    }

    /// Execute NetTask decoding the result
    @discardableResult public func executeDecoding<D: Decodable>(by kommander: Kommander,
                                                                 after delay: DispatchTimeInterval? = nil,
                                                                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                                                 dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                                                 nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
                                                                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                                                 userInfo: [CodingUserInfoKey : Any] = [:],
                                                                 success: ((_ result: D) -> Void)?,
                                                                 error: ((_ error: Error?) -> Void)?) -> Kommand<D> {
        let kommand = kommander.make {
            return try self.sync().decode(dateDecodingStrategy: dateDecodingStrategy,
                                          dataDecodingStrategy: dataDecodingStrategy,
                                          nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                                          keyDecodingStrategy: keyDecodingStrategy,
                                          userInfo: userInfo)
        }.success {
            success?($0)
        }.error {
            error?($0)
        }
        if let delay = delay {
            kommand.execute(after: delay)
        } else {
            kommand.execute()
        }
        return kommand
    }

}
