//
//  NetURLSession+AsyncStream.swift
//  Net
//
//  Created by Alex Rupérez on 17/3/17.
//
//

@available(iOS 9.0, *)
public extension NetURLSession {

    public func stream(_ netService: NetService) -> NetTask {
        let task = session.streamTask(with: netService)
        let netStreamTask = netTask(task)
        observe(task, netStreamTask)
        task.resume()
        return netStreamTask
    }

    public func stream(_ domain: String, type: String, name: String = "", port: Int32? = nil) -> NetTask {
        guard let port = port else {
            return stream(NetService(domain: domain, type: type, name: name))
        }
        return stream(NetService(domain: domain, type: type, name: name, port: port))
    }

    public func stream(_ hostName: String, port: Int) -> NetTask {
        let task = session.streamTask(withHostName: hostName, port: port)
        let netStreamTask = netTask(task)
        observe(task, netStreamTask)
        task.resume()
        return netStreamTask
    }

}
