//
//  NetURLSession+SyncDownload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data) throws -> NetResponse {
        var downloadResponse: NetResponse?
        var downloadError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = download(resumeData, completion: { (response, error) in
            downloadResponse = response
            downloadError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let downloadError = downloadError {
            throw downloadError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return downloadResponse!
    }

    public func download(_ request: NetRequest) throws -> NetResponse {
        var downloadResponse: NetResponse?
        var downloadError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = download(request, completion: { (response, error) in
            downloadResponse = response
            downloadError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let downloadError = downloadError {
            throw downloadError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return downloadResponse!
    }

    public func download(_ request: URLRequest) throws -> NetResponse {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return try download(netRequest)
    }

    public func download(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        return try download(netRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func download(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
