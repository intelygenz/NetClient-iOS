//
//  NetAlamofire+Download.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Alamofire

extension NetAlamofire {

    public func download(_ resumeData: Data) -> NetTask {
        let downloadRequest = sessionManager.download(resumingWith: resumeData)
        downloadRequest.suspend()
        var netDownloadTask: NetTask?
        downloadRequest.downloadProgress(queue: queue) { progress in
            netDownloadTask?.progress = progress
            netDownloadTask?.progressClosure?(progress)
        }
        .validate(statusCode: acceptableStatusCodes)
        .response(queue: queue) { [weak self] response in
            let netResponse = self?.netResponse(response.response, netDownloadTask, response.destinationURL)
            let netError = self?.netError(response.error, response.destinationURL, response.response)
            netDownloadTask?.response = netResponse
            netDownloadTask?.error = netError
            #if !os(watchOS)
            if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *), let metrics = response.metrics {
                netDownloadTask?.metrics = NetTaskMetrics(metrics, response: netResponse)
            }
            #endif
            netDownloadTask?.dispatchSemaphore?.signal()
            netDownloadTask?.completionClosure?(netResponse, netError)
        }
        netDownloadTask = netTask(downloadRequest)
        return netDownloadTask!
    }

    public func download(_ request: NetRequest) -> NetTask {
        let downloadRequest = sessionManager.download(urlRequest(request))
        downloadRequest.suspend()
        var netDownloadTask: NetTask?
        downloadRequest.downloadProgress(queue: queue) { progress in
            netDownloadTask?.progress = progress
            netDownloadTask?.progressClosure?(progress)
        }
        .validate(statusCode: acceptableStatusCodes)
        .response(queue: queue) { [weak self] response in
            let netResponse = self?.netResponse(response.response, netDownloadTask, response.destinationURL)
            let netError = self?.netError(response.error, response.destinationURL, response.response)
            netDownloadTask?.response = netResponse
            netDownloadTask?.error = netError
            #if !os(watchOS)
            if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *), let metrics = response.metrics {
                netDownloadTask?.metrics = NetTaskMetrics(metrics, request: request, response: netResponse)
            }
            #endif
            netDownloadTask?.dispatchSemaphore?.signal()
            netDownloadTask?.completionClosure?(netResponse, netError)
        }
        netDownloadTask = netTask(downloadRequest)
        return netDownloadTask!
    }

    public func download(_ request: URLRequest) throws -> NetTask {
        guard let netRequest = request.netRequest else {
            throw netError(URLError(.badURL))!
        }
        return download(netRequest)
    }

    public func download(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> NetTask {
        return download(netRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func download(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw netError(URLError(.badURL))!
        }
        return download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
