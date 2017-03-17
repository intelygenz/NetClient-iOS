//
//  NetURLSession+AsyncData.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 17/3/17.
//
//

public extension NetURLSession {

    public func download(_ resumeData: Data, completion: ((URL?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(withResumeData: resumeData)
            task.resume()
            return task
        }
        let task = session.downloadTask(withResumeData: resumeData, completionHandler: completion)
        task.resume()
        return task
    }

    public func download(_ request: URLRequest, completion: ((URL?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        guard let completion = completion else {
            let task = session.downloadTask(with: request)
            task.resume()
            return task
        }
        let task = session.downloadTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }

    public func download(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((URL?, URLResponse?, Error?) -> Swift.Void)? = nil) -> URLSessionTask {
        return download(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), completion: completion)
    }

    public func download(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, completion: ((URL?, URLResponse?, Error?) -> Swift.Void)? = nil) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return download(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, completion: completion)
    }

}
