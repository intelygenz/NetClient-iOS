//
//  NetAlamofire+Stream.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

import Alamofire

#if !os(watchOS)
@available(iOS 9.0, OSX 10.11, *)
extension NetAlamofire {

    open func stream(_ netService: NetService) -> NetTask {
        let streamRequest = sessionManager.stream(with: netService)
        streamRequest.suspend()
        return netTask(streamRequest)!
    }

    open func stream(_ domain: String, type: String, name: String, port: Int32?) -> NetTask {
        guard let port = port else {
            return stream(NetService(domain: domain, type: type, name: name))
        }
        return stream(NetService(domain: domain, type: type, name: name, port: port))
    }

    open func stream(_ hostName: String, port: Int) -> NetTask {
        let streamRequest = sessionManager.stream(withHostName: hostName, port: port)
        streamRequest.suspend()
        return netTask(streamRequest)!
    }

}
#endif
