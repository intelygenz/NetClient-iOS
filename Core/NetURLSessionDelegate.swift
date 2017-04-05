//
//  NetURLSessionDelegate.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Foundation

class NetURLSessionDelegate: NSObject {

    fileprivate weak final var netURLSession: NetURLSession?

    final var tasks = [URLSessionTask: NetTask]()

    init(_ urlSession: NetURLSession) {
        netURLSession = urlSession
        super.init()
    }

    func add(_ task: URLSessionTask, _ netTask: NetTask) {
        tasks[task] = netTask
    }

    deinit {
        tasks.removeAll()
        netURLSession = nil
    }

}

extension NetURLSessionDelegate: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        handle(challenge, completion: completionHandler)
    }

}

extension NetURLSessionDelegate: URLSessionTaskDelegate {

    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        handle(challenge, completion: completionHandler)
    }

    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting taskMetrics: URLSessionTaskMetrics) {
        if let netTask = tasks[task] {
            netTask.metrics = NetTaskMetrics(taskMetrics, request: netTask.request, response: netTask.response)
        }
        tasks[task] = nil
    }

}

extension NetURLSessionDelegate: URLSessionDataDelegate {}


extension NetURLSessionDelegate: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {}
    
}

@available(iOS 9.0, *)
extension NetURLSessionDelegate: URLSessionStreamDelegate {}

extension NetURLSessionDelegate {

    fileprivate func handle(_ challenge: URLAuthenticationChallenge, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        guard let authChallenge = netURLSession?.authChallenge else {
            if let realm = challenge.protectionSpace.realm {
                print(realm)
                print(challenge.protectionSpace.authenticationMethod)
            }
            completion(.useCredential, nil)
            return
        }
        authChallenge(challenge, completion)
    }

}
