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
        handle(challenge, tasks[task], completion: completionHandler)
    }

    @available(iOS 10.0, tvOS 10.0, watchOS 3.0, OSX 10.12, *)
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

    fileprivate func handle(_ challenge: URLAuthenticationChallenge, _ task: NetTask? = nil, completion: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        guard let authChallenge = netURLSession?.authChallenge else {
            var credential: URLCredential? = challenge.proposedCredential
            if credential?.hasPassword != true, let request = task?.request {
                switch request.authorization {
                case .basic(let user, let password):
                    credential = URLCredential(user: user, password: password, persistence: .forSession)
                default:
                    break
                }
            }
            if credential?.hasPassword != true, let serverTrust = challenge.protectionSpace.serverTrust {
                credential = URLCredential(trust: serverTrust)
            }
            if credential == nil, let realm = challenge.protectionSpace.realm {
                print(realm)
                print(challenge.protectionSpace.authenticationMethod)
            }
            completion(.useCredential, credential)
            return
        }
        authChallenge(challenge, completion)
    }

}
