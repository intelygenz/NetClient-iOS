//
//  NetURLSessionDelegate.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Foundation

class NetURLSessionDelegate: NSObject, URLSessionDelegate {

    let netURLSession: NetURLSession

    init(_ netURLSession: NetURLSession) {
        self.netURLSession = netURLSession
    }

    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        netURLSession.authChallenge?(challenge, completionHandler)
    }

}
