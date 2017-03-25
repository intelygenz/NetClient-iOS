//
//  NetURLSession+SyncData.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func data(_ request: NetRequest) throws -> NetResponse {
        return try data(request.urlRequest)
    }

    public func data(_ request: URLRequest) throws -> NetResponse {
        var dataResponse: NetResponse?
        var dataError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = data(request, completion: { (response, error) in
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

    public func data(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        return try data(netRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func data(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetResponse {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
