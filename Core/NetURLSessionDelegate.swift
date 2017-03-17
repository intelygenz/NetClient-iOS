//
//  NetURLSessionDelegate.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Foundation

class NetURLSessionDelegate: NSObject {

    let netURLSession: NetURLSession

    init(_ netURLSession: NetURLSession) {
        self.netURLSession = netURLSession
    }

}

extension NetURLSessionDelegate: URLSessionDelegate {

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        netURLSession.authChallenge?(challenge, completionHandler)
    }

}

extension NetURLSessionDelegate: URLSessionTaskDelegate {
    
}

extension NetURLSessionDelegate: URLSessionDataDelegate {
    
}


extension NetURLSessionDelegate: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }
    
}

extension NetURLSessionDelegate: URLSessionStreamDelegate {

    
    
}
