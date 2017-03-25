//
//  NetURLSession+AsyncDownload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(withResumeData: resumeData)
            observe(task)
            task.resume()
            return task
        }
        let task = session.downloadTask(withResumeData: resumeData) { (url, response, error) in
            completion(self.netResponse(response, url), self.netError(error))
        }
        observe(task)
        task.resume()
        return task
    }

    public func download(_ request: NetRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return download(request.urlRequest, completion: completion)
    }

    public func download(_ request: URLRequest, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(with: request)
            observe(task)
            task.resume()
            return task
        }
        let task = session.downloadTask(with: request) { (url, response, error) in
            completion(self.netResponse(response, url), self.netError(error))
        }
        observe(task)
        task.resume()
        return task
    }

    public func download(_ url: URL, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return download(netRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func download(_ urlString: String, cachePolicy: NetRequest.NetCachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
