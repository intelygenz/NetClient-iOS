//
//  NetStub+Stream.swift
//  Net
//
//  Created by Alex Rupérez on 24/1/18.
//

#if !os(watchOS)
@available(iOS 9.0, macOS 10.11, *)
extension NetStub {

    public func stream(_ netService: NetService) -> NetTask {
        return stub()
    }

    public func stream(_ domain: String, type: String, name: String = "", port: Int32? = nil) -> NetTask {
        return stub()
    }

    public func stream(_ hostName: String, port: Int) -> NetTask {
        return stub()
    }

}
#endif
