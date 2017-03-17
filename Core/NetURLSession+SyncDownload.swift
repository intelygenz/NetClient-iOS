//
//  NetURLSession+SyncDownload.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data) throws -> URL? {
        var locationObject: URL?
        var locationError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = download(resumeData, completion: { (location, response, error) in
            locationObject = location
            locationError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let locationError = locationError {
            throw locationError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return locationObject
    }

    public func download(_ request: URLRequest) throws -> URL? {
        var locationObject: URL?
        var locationError: Error?
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        _ = download(request, completion: { (location, response, error) in
            locationObject = location
            locationError = error
            dispatchSemaphore.signal()
        })
        let dispatchTimeoutResult = dispatchSemaphore.wait(timeout: DispatchTime.distantFuture)
        if let locationError = locationError {
            throw locationError
        }
        if dispatchTimeoutResult == .timedOut {
            throw URLError(.timedOut)
        }
        return locationObject
    }

    public func download(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> URL? {
        return try download(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func download(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> URL? {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return try download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
