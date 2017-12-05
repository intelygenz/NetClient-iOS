//
//  NetAlamofire+Data.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Alamofire

extension NetAlamofire {

    open func data(_ request: NetRequest) -> NetTask {
        let dataRequest = sessionManager.request(urlRequest(request))
        dataRequest.suspend()
        var netDataTask: NetTask?
        dataRequest.downloadProgress(queue: queue) { progress in
            netDataTask?.progress = progress
            netDataTask?.progressClosure?(progress)
        }
        dataRequest.response(queue: queue) { [weak self] response in
            let netResponse = self?.netResponse(response.response, netDataTask, response.data)
            let netError = self?.netError(response.error, response.data, response.response)
            netDataTask?.response = netResponse
            netDataTask?.error = netError
            #if !os(watchOS)
            if #available(iOS 10.0, tvOS 10.0, watchOS 3.0, macOS 10.12, *), let metrics = response.metrics {
                netDataTask?.metrics = NetTaskMetrics(metrics, request: request, response: netResponse)
            }
            #endif
            netDataTask?.dispatchSemaphore?.signal()
            netDataTask?.completionClosure?(netResponse, netError)
        }
        netDataTask = netTask(dataRequest, request)
        return netDataTask!
    }

    open func data(_ request: URLRequest) throws -> NetTask {
        guard let netRequest = request.netRequest else {
            throw netError(URLError(.badURL))!
        }
        return data(netRequest)
    }

    open func data(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> NetTask {
        return data(netRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    open func data(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw netError(URLError(.badURL))!
        }
        return data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
