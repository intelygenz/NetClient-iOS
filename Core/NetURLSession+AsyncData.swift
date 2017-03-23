//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func data(_ request: NetRequest, completion: ((Data?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return data(request.urlRequest, completion: completion)
    }

    public func data(_ request: URLRequest, completion: ((Data?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.dataTask(with: request)
            observe(task)
            task.resume()
            return task
        }
        let task = session.dataTask(with: request) { (data, response, error) in
            completion(data, self.netResponse(response), self.netError(error))
        }
        observe(task)
        task.resume()
        return task
    }

    public func data(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return data(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func data(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((Data?, NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return data(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
