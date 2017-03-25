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
        let task = session.downloadTask(withResumeData: resumeData) { (url, response, error) in
            completion(self.netResponse(response, url), self.netError(error))
        }
        let netDownloadTask = netTask(task)
        observe(task, netDownloadTask)
        task.resume()
        return netDownloadTask
    }

    public func download(_ request: NetRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        return download(request.urlRequest, completion: completion)
    }

    public func download(_ request: URLRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> NetTask {
        guard let completion = completion else {
            let task = session.downloadTask(with: request)
            let netDownloadTask = netTask(task)
            observe(task, netDownloadTask)
            task.resume()
            return netDownloadTask
        }
        let task = session.downloadTask(with: request) { (url, response, error) in
            completion(self.netResponse(response, url), self.netError(error))
        }
        let netDownloadTask = netTask(task)
        observe(task, netDownloadTask)
        task.resume()
        return netDownloadTask
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
