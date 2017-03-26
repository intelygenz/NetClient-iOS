//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

extension NetURLSession {

    public func data(_ request: NetRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.dataTask(with: request.urlRequest)
            let netDataTask = netTask(task, request)
            observe(task, netDataTask)
            task.resume()
            return netDataTask
        }
        var netDataTask: NetTask!
        let task = session.dataTask(with: request.urlRequest) { (data, response, error) in
            let netResponse = self.netResponse(response, data)
            let netError = self.netError(error)
            netDataTask.response = netResponse
            netDataTask.error = netError
            completion(netResponse, netError)
        }
        netDataTask = netTask(task, request)
        observe(task, netDataTask)
        task.resume()
        return netDataTask
    }

    public func data(_ request: URLRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return data(netRequest, completion: completion)
    }

    public func data(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return data(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func data(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
