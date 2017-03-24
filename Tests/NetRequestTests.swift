//
//  NetRequestTests.swift
//  NetTests
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import XCTest
@testable import Net

class NetRequestTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testNetCachePolicy() {
        XCTAssertEqual(NetRequest.NetCachePolicy.useProtocolCachePolicy.rawValue, URLRequest.CachePolicy.useProtocolCachePolicy.rawValue)
        XCTAssertEqual(NetRequest.NetCachePolicy.reloadIgnoringLocalCacheData.rawValue, URLRequest.CachePolicy.reloadIgnoringLocalCacheData.rawValue)
        XCTAssertEqual(NetRequest.NetCachePolicy.returnCacheDataElseLoad.rawValue, URLRequest.CachePolicy.returnCacheDataElseLoad.rawValue)
        XCTAssertEqual(NetRequest.NetCachePolicy.returnCacheDataDontLoad.rawValue, URLRequest.CachePolicy.returnCacheDataDontLoad.rawValue)
    }

    func testNetServiceType() {
        XCTAssertEqual(NetRequest.NetServiceType.default.rawValue, URLRequest.NetworkServiceType.default.rawValue)
        XCTAssertEqual(NetRequest.NetServiceType.voip.rawValue, URLRequest.NetworkServiceType.voip.rawValue)
        XCTAssertEqual(NetRequest.NetServiceType.video.rawValue, URLRequest.NetworkServiceType.video.rawValue)
        XCTAssertEqual(NetRequest.NetServiceType.background.rawValue, URLRequest.NetworkServiceType.background.rawValue)
        XCTAssertEqual(NetRequest.NetServiceType.voice.rawValue, URLRequest.NetworkServiceType.voice.rawValue)
        if #available(iOS 10.0, *) {
            XCTAssertEqual(NetRequest.NetServiceType.callSignaling.rawValue, URLRequest.NetworkServiceType.networkServiceTypeCallSignaling.rawValue)
        }
    }

    override func tearDown() {
        super.tearDown()
    }
    
}
