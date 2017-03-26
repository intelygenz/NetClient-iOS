//
//  NetURLSession+SyncUpload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

extension NetURLSession {

    public func upload(_ request: NetRequest, data: Data) throws -> NetResponse {
        var uploadResponse: NetResponse?
        var uploadError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = upload(request, data: data, completion: { (response, error) in
            uploadResponse = response
            uploadError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let uploadError = uploadError {
            throw uploadError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return uploadResponse!
    }

    public func upload(_ request: URLRequest, data: Data) throws -> NetResponse {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return try upload(netRequest, data: data)
    }

    public func upload(_ url: URL, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        return try upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), data: data)
    }

    public func upload(_ urlString: String, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try upload(url, data: data, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

    public func upload(_ request: NetRequest, fileURL: URL) throws -> NetResponse {
        var dataResponse: NetResponse?
        var dataError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = upload(request, fileURL: fileURL, completion: { (response, error) in
            dataResponse = response
            dataError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let dataError = dataError {
            throw dataError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return dataResponse!
    }

    public func upload(_ request: URLRequest, fileURL: URL) throws -> NetResponse {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return try upload(netRequest, fileURL: fileURL)
    }

    public func upload(_ url: URL, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        return try upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), fileURL: fileURL)
    }

    public func upload(_ urlString: String, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try upload(url, fileURL: fileURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
