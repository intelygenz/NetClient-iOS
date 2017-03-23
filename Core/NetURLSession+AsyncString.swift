//
//  NetURLSession+AsyncString.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

public extension NetURLSession {

    public func string(_ request: NetRequest, encoding: String.Encoding = .utf8, completion: @escaping (String?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return string(request.urlRequest, encoding: encoding, completion: completion)
    }

    public func string(_ request: URLRequest, encoding: String.Encoding = .utf8, completion: @escaping (String?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return data(request, completion: { (data, response, error) in
            guard let data = data, data.count > 0 else {
                completion(nil, response, error)
                return
            }
            completion(self.string(data, encoding: encoding), response, error)
        })
    }

    public func string(_ url: URL, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, encoding: String.Encoding = .utf8, completion: @escaping (String?, NetResponse?, NetError?) -> Swift.Void) -> URLSessionTask {
        return string(urlRequest(url, cache: cachePolicy, timeout: timeoutInterval), encoding: encoding, completion: completion)
    }

    public func string(_ urlString: String, cachePolicy: URLRequest.CachePolicy? = nil, timeoutInterval: TimeInterval? = nil, encoding: String.Encoding = .utf8, completion: @escaping (String?, NetResponse?, NetError?) -> Swift.Void) throws -> URLSessionTask {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        return string(url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval, encoding: encoding, completion: completion)
    }

}
