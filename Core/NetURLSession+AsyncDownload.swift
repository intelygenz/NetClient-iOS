//
//  NetURLSession+AsyncDownload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.downloadTask(withResumeData: resumeData)
            let netDownloadTask = netTask(task)
            observe(task, netDownloadTask)
            task.resume()
            return netDownloadTask
        }
        var netDownloadTask: NetTask!
        let task = session.downloadTask(withResumeData: resumeData) { (url, response, error) in
            let netResponse = self.netResponse(response, url)
            let netError = self.netError(error)
            netDownloadTask.response = netResponse
            netDownloadTask.error = netError
            completion(netResponse, netError)
        }
        netDownloadTask = netTask(task)
        observe(task, netDownloadTask)
        task.resume()
        return netDownloadTask
    }

    public func download(_ request: NetRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.downloadTask(with: request.urlRequest)
            let netDownloadTask = netTask(task, request)
            observe(task, netDownloadTask)
            task.resume()
            return netDownloadTask
        }
        var netDownloadTask: NetTask!
        let task = session.downloadTask(with: request.urlRequest) { (url, response, error) in
            let netResponse = self.netResponse(response, url)
            let netError = self.netError(error)
            netDownloadTask.response = netResponse
            netDownloadTask.error = netError
            completion(netResponse, netError)
        }
        netDownloadTask = netTask(task, request)
        observe(task, netDownloadTask)
        task.resume()
        return netDownloadTask
    }

    public func download(_ request: URLRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let netRequest = NetRequest(request) else {
            throw URLError(.badURL)
        }
        return download(netRequest, completion: completion)
    }

    public func download(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return download(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func download(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> NetTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
