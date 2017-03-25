//
//  NetURLSession+AsyncUpload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func upload(_ streamedRequest: NetRequest) -> NetTask {
        return upload(streamedRequest.urlRequest)
    }

    public func upload(_ streamedRequest: URLRequest) -> NetTask {
        let task = session.uploadTask(withStreamedRequest: streamedRequest)
        let netUploadTask = netTask(task)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ streamedURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) -> NetTask {
        return upload(netRequest(streamedURL, cache: cachePolicy, timeout: timeoutInterval))
    }

    public func upload(_ streamedURLString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil) throws -> NetTask {
        guard let url = URL(string: streamedURLString) else {
            throw URLError(.badURL)
        }
        return upload(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }

    public func upload(_ request: NetRequest, data: Data, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return upload(request.urlRequest, data: data, completion: completion)
    }

    public func upload(_ request: URLRequest, data: Data, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.uploadTask(with: request, from: data)
            let netUploadTask = netTask(task)
            observe(task, netUploadTask)
            task.resume()
            return netUploadTask
        }
        let task = session.uploadTask(with: request, from: data) { (data, response, error) in
            completion(self.netResponse(response, data), self.netError(error))
        }
        let netUploadTask = netTask(task)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ url: URL, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), data: data, completion: completion)
    }

    public func upload(_ urlString: String, data: Data, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return upload(url, data: data, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

    public func upload(_ request: NetRequest, fileURL: URL, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return upload(request.urlRequest, fileURL: fileURL, completion: completion)
    }

    public func upload(_ request: URLRequest, fileURL: URL, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.uploadTask(with: request, fromFile: fileURL)
            let netUploadTask = netTask(task)
            observe(task, netUploadTask)
            task.resume()
            return netUploadTask
        }
        let task = session.uploadTask(with: request, fromFile: fileURL) { (data, response, error) in
            completion(self.netResponse(response, data), self.netError(error))
        }
        let netUploadTask = netTask(task)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ url: URL, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return upload(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), fileURL: fileURL, completion: completion)
    }

    public func upload(_ urlString: String, fileURL: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return upload(url, fileURL: fileURL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
