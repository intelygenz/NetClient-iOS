//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func data(_ request: NetRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return data(request.urlRequest, completion: completion)
    }

    public func data(_ request: URLRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.dataTask(with: request)
            let netDataTask = netTask(task)
            observe(task, netDataTask)
            task.resume()
            return netDataTask
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(self.netResponse(response, data), self.netError(error))
        }
        let netDataTask = netTask(task)
        observe(task, netDataTask)
        task.resume()
        return netDataTask
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
