//
//  NetURLSession+Data.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

extension NetURLSession {

    public func data(_ request: NetRequest) -> NetTask {
        var netDataTask: NetTask!
        let task = session.dataTask(with: request.urlRequest) { (data, response, error) in
            let netResponse = self.netResponse(response, data)
            let netError = self.netError(error)
            netDataTask.response = netResponse
            netDataTask.error = netError
            netDataTask.dispatchSemaphore?.signal()
            netDataTask.completionClosure?(netResponse, netError)
        }
        netDataTask = netTask(task, request)
        observe(task, netDataTask)
        return netDataTask
    }

    public func data(_ request: URLRequest) throws -> NetTask {
        guard let netRequest = NetRequest(request) else {
            throw netError(URLError(.badURL))!
        }
        return data(netRequest)
    }

    public func data(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> NetTask {
        return data(netRequest(url, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func data(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw netError(URLError(.badURL))!
        }
        return data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

}
