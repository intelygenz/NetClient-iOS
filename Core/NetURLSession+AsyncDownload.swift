//
//  NetURLSession+AsyncDownload.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data, completion: ((URL?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(withResumeData: resumeData)
            observe(task)
            task.resume()
            return task
        }
        let task = session.downloadTask(withResumeData: resumeData) { (url, response, error) in
            completion(url, self.netResponse(response), self.netError(error))
        }
        observe(task)
        task.resume()
        return task
    }

    public func download(_ request: NetRequest, completion: ((URL?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return download(request.urlRequest, completion: completion)
    }

    public func download(_ request: URLRequest, completion: ((URL?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(with: request)
            observe(task)
            task.resume()
            return task
        }
        let task = session.downloadTask(with: request) { (url, response, error) in
            completion(url, self.netResponse(response), self.netError(error))
        }
        observe(task)
        task.resume()
        return task
    }

    public func download(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((URL?, NetResponse?, NetError?) -> Swift.Void)? = nil) -> URLSessionTask {
        return download(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func download(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((URL?, NetResponse?, NetError?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
