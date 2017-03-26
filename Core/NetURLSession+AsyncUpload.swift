//
//  NetURLSession+AsyncUpload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

extension NetURLSession {

    public func upload(_ streamedRequest: NetRequest) -> NetTask {
        let task = session.uploadTask(withStreamedRequest: streamedRequest.urlRequest)
        let netUploadTask = netTask(task, streamedRequest)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ streamedRequest: URLRequest) throws -> NetTask {
        guard let netRequest = NetRequest(streamedRequest) else {
            throw URLError(.badURL)
        }
        return upload(netRequest)
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
        guard let completion = completion else {
            let task = session.uploadTask(with: request.urlRequest, from: data)
            let netUploadTask = netTask(task, request)
            observe(task, netUploadTask)
            task.resume()
            return netUploadTask
        }
        var netUploadTask: NetTask!
        let task = session.uploadTask(with: request.urlRequest, from: data) { (data, response, error) in
            let netResponse = self.netResponse(response, data)
            let netError = self.netError(error)
            netUploadTask.response = netResponse
            netUploadTask.error = netError
            completion(netResponse, netError)
        }
        netUploadTask = netTask(task, request)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ request: URLRequest, data: Data, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return upload(netRequest, data: data, completion: completion)
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
        guard let completion = completion else {
            let task = session.uploadTask(with: request.urlRequest, fromFile: fileURL)
            let netUploadTask = netTask(task, request)
            observe(task, netUploadTask)
            task.resume()
            return netUploadTask
        }
        var netUploadTask: NetTask!
        let task = session.uploadTask(with: request.urlRequest, fromFile: fileURL) { (data, response, error) in
            let netResponse = self.netResponse(response, data)
            let netError = self.netError(error)
            netUploadTask.response = netResponse
            netUploadTask.error = netError
            completion(netResponse, netError)
        }
        netUploadTask = netTask(task, request)
        observe(task, netUploadTask)
        task.resume()
        return netUploadTask
    }

    public func upload(_ request: URLRequest, fileURL: URL, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return upload(netRequest, fileURL: fileURL, completion: completion)
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
