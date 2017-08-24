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

    func testNetAuthorization() {
        XCTAssertEqual(NetAuthorization.basic(user: "user", password: "password"), NetAuthorization(rawValue: "Basic dXNlcjpwYXNzd29yZA=="))
        XCTAssertNotEqual(NetAuthorization.basic(user: "user", password: "wordpass"), NetAuthorization(rawValue: "Basic dXNlcjpwYXNzd29yZA=="))
        XCTAssertEqual(NetAuthorization.basic(user: "", password: ""), NetAuthorization(rawValue: "Basic "))
        XCTAssertEqual(NetAuthorization.bearer(token: "token"), NetAuthorization(rawValue: "Bearer token"))
        XCTAssertNotEqual(NetAuthorization.bearer(token: "kento"), NetAuthorization(rawValue: "Bearer token"))
        XCTAssertEqual(NetAuthorization.custom("Custom authorization"), NetAuthorization(rawValue: "Custom authorization"))
        XCTAssertNotEqual(NetAuthorization.custom("Authorization custom"), NetAuthorization(rawValue: "Custom authorization"))
        XCTAssertEqual(NetAuthorization.none, NetAuthorization(rawValue: ""))
    }

    func testNetCacheControl() {
        XCTAssertEqual(NetCacheControl.maxAge(10), NetCacheControl(rawValue: "max-age=10"))
        XCTAssertNotEqual(NetCacheControl.maxAge(20), NetCacheControl(rawValue: "max-age=10"))
        XCTAssertEqual(NetCacheControl.maxAge(10.5), NetCacheControl(rawValue: "max-age=10.5"))
        XCTAssertNotEqual(NetCacheControl.maxAge(20.5), NetCacheControl(rawValue: "max-age=10.5"))
        XCTAssertEqual(NetCacheControl.maxStale(10), NetCacheControl(rawValue: "max-stale=10"))
        XCTAssertNotEqual(NetCacheControl.maxStale(20), NetCacheControl(rawValue: "max-stale=10"))
        XCTAssertEqual(NetCacheControl.maxStale(10.5), NetCacheControl(rawValue: "max-stale=10.5"))
        XCTAssertNotEqual(NetCacheControl.maxStale(20.5), NetCacheControl(rawValue: "max-stale=10.5"))
        XCTAssertEqual(NetCacheControl.maxStale(nil), NetCacheControl(rawValue: "max-stale"))
        XCTAssertEqual(NetCacheControl.minFresh(10), NetCacheControl(rawValue: "min-fresh=10"))
        XCTAssertNotEqual(NetCacheControl.minFresh(20), NetCacheControl(rawValue: "min-fresh=10"))
        XCTAssertEqual(NetCacheControl.minFresh(10.5), NetCacheControl(rawValue: "min-fresh=10.5"))
        XCTAssertNotEqual(NetCacheControl.minFresh(20.5), NetCacheControl(rawValue: "min-fresh=10.5"))
        XCTAssertEqual(NetCacheControl.noCache, NetCacheControl(rawValue: "no-cache"))
        XCTAssertEqual(NetCacheControl.noStore, NetCacheControl(rawValue: "no-store"))
        XCTAssertEqual(NetCacheControl.noTransform, NetCacheControl(rawValue: "no-transform"))
        XCTAssertEqual(NetCacheControl.onlyIfCached, NetCacheControl(rawValue: "only-if-cached"))
        XCTAssertEqual(NetCacheControl.custom("Custom cache"), NetCacheControl(rawValue: "Custom cache"))
        XCTAssertNotEqual(NetCacheControl.custom("Cache custom"), NetCacheControl(rawValue: "Custom cache"))
    }

    func testNetRequestBuilder() {
        let url = URL(string: "http://www.alexruperez.com/entries/3491-intelygenz-netclient-ios.json")!
        let builder = NetRequest(url).builder()
        let body = "body".data(using: .utf8)
        builder.addAcceptEncoding(NetRequest.NetContentEncoding.gzip).addAcceptEncoding(NetRequest.NetContentEncoding.deflate).setBody(body).setURLParameters(["foo": "bar", "igz": "rules"])
        var urlRequest = builder.build().urlRequest
        XCTAssertEqual(urlRequest.value(forHTTPHeaderField: "Accept-Encoding"), "gzip, deflate")
        XCTAssertEqual(urlRequest.httpBody, body)
        XCTAssertEqual(urlRequest.url?.absoluteString, url.absoluteString + "?foo=bar&igz=rules")
        builder.addURLParameter("intelygenz", value: "cool")
        urlRequest = builder.build().urlRequest
        XCTAssertEqual(urlRequest.url?.absoluteString, url.absoluteString + "?foo=bar&igz=rules&intelygenz=cool")
        builder.setURLParameters(nil)
        urlRequest = builder.build().urlRequest
        XCTAssertEqual(urlRequest.url?.absoluteString, url.absoluteString)
    }

    func testNetTransformer() {
        let string = "string"
        let data = string.data(using: .utf8)
        let dictionary = ["foo": "var"]
        XCTAssertEqual(try NetTransformer.object(object: string), string)
        XCTAssertEqual(try NetTransformer.object(object: data), data)
        XCTAssertEqual(try NetTransformer.object(object: data), string)
        let json = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        XCTAssertEqual(try NetTransformer.object(object: json), dictionary)
        let plist = try! PropertyListSerialization.data(fromPropertyList: dictionary, format: .binary, options: 0)
        XCTAssertEqual(try NetTransformer.object(object: plist), dictionary)
    }

    override func tearDown() {
        super.tearDown()
    }
    
}
