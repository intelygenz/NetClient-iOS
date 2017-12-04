//
//  URLSessionConfiguration+Build.swift
//  Net
//
//  Created by Alex Rupérez on 4/12/17.
//

import Foundation

extension URLSessionConfiguration {

    open class Builder {

        public enum MultipathServiceType: Int {
            case none, handover, interactive, aggregate
        }

        open private(set) var requestCachePolicy: NSURLRequest.CachePolicy

        open private(set) var timeoutIntervalForRequest: TimeInterval

        open private(set) var timeoutIntervalForResource: TimeInterval

        open private(set) var networkServiceType: NSURLRequest.NetworkServiceType

        open private(set) var allowsCellularAccess: Bool

        open private(set) var waitsForConnectivity = false

        open private(set) var isDiscretionary: Bool

        open private(set) var sharedContainerIdentifier: String?

        open private(set) var sessionSendsLaunchEvents: Bool

        open private(set) var connectionProxyDictionary: [AnyHashable : Any]?

        open private(set) var tlsMinimumSupportedProtocol: SSLProtocol

        open private(set) var tlsMaximumSupportedProtocol: SSLProtocol

        open private(set) var httpShouldUsePipelining: Bool

        open private(set) var httpShouldSetCookies: Bool

        open private(set) var httpCookieAcceptPolicy: HTTPCookie.AcceptPolicy

        open private(set) var httpAdditionalHeaders: [AnyHashable : Any]?

        open private(set) var httpMaximumConnectionsPerHost: Int

        open private(set) var httpCookieStorage: HTTPCookieStorage?

        open private(set) var urlCredentialStorage: URLCredentialStorage?

        open private(set) var urlCache: URLCache?

        open private(set) var shouldUseExtendedBackgroundIdleMode = false

        open private(set) var protocolClasses: [Swift.AnyClass]?

        open private(set) var multipathServiceType = MultipathServiceType.none

        public init(_ configuration: URLSessionConfiguration? = nil) {
            requestCachePolicy = configuration?.requestCachePolicy ?? .useProtocolCachePolicy
            timeoutIntervalForRequest = configuration?.timeoutIntervalForRequest ?? 0
            timeoutIntervalForResource = configuration?.timeoutIntervalForResource ?? 0
            networkServiceType = configuration?.networkServiceType ?? .default
            allowsCellularAccess = configuration?.allowsCellularAccess ?? true
            if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *), let waitsForConnectivity = configuration?.waitsForConnectivity {
                self.waitsForConnectivity = waitsForConnectivity
            }
            isDiscretionary = configuration?.isDiscretionary ?? false
            sharedContainerIdentifier = configuration?.sharedContainerIdentifier
            sessionSendsLaunchEvents = configuration?.sessionSendsLaunchEvents ?? true
            connectionProxyDictionary = configuration?.connectionProxyDictionary
            tlsMinimumSupportedProtocol = configuration?.tlsMinimumSupportedProtocol ?? .sslProtocol3
            tlsMaximumSupportedProtocol = configuration?.tlsMaximumSupportedProtocol ?? .tlsProtocol12
            httpShouldUsePipelining = configuration?.httpShouldUsePipelining ?? false
            httpShouldSetCookies = configuration?.httpShouldSetCookies ?? true
            httpCookieAcceptPolicy = configuration?.httpCookieAcceptPolicy ?? .onlyFromMainDocumentDomain
            httpAdditionalHeaders = configuration?.httpAdditionalHeaders
            httpMaximumConnectionsPerHost = configuration?.httpMaximumConnectionsPerHost ?? 6
            httpCookieStorage = configuration?.httpCookieStorage
            urlCredentialStorage = configuration?.urlCredentialStorage
            urlCache = configuration?.urlCache
            if #available(iOS 9.0, tvOS 9.0, watchOS 2.0, macOS 10.11, *), let shouldUseExtendedBackgroundIdleMode = configuration?.shouldUseExtendedBackgroundIdleMode {
                self.shouldUseExtendedBackgroundIdleMode = shouldUseExtendedBackgroundIdleMode
            }
            protocolClasses = configuration?.protocolClasses
            if #available(iOS 11.0, *), let multipathServiceTypeRawValue = configuration?.multipathServiceType.rawValue, let multipathServiceType = MultipathServiceType(rawValue: multipathServiceTypeRawValue) {
                self.multipathServiceType = multipathServiceType
            }
        }

        @discardableResult open func setCachePolicy(_ requestCachePolicy: NSURLRequest.CachePolicy) -> Self {
            self.requestCachePolicy = requestCachePolicy
            return self
        }

        public func build() -> URLSessionConfiguration {
            return URLSessionConfiguration(self)
        }

    }

    public static func builder(_ configuration: URLSessionConfiguration? = nil) -> Builder {
        return Builder(configuration)
    }

    public convenience init(_ builder: Builder) {

        self.init()

        requestCachePolicy = builder.requestCachePolicy

        timeoutIntervalForRequest = builder.timeoutIntervalForRequest

        timeoutIntervalForResource = builder.timeoutIntervalForResource

        networkServiceType = builder.networkServiceType

        allowsCellularAccess = builder.allowsCellularAccess

        if #available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *) {
            waitsForConnectivity = builder.waitsForConnectivity
        }

        isDiscretionary = builder.isDiscretionary

        sharedContainerIdentifier = builder.sharedContainerIdentifier

        sessionSendsLaunchEvents = builder.sessionSendsLaunchEvents

        connectionProxyDictionary = builder.connectionProxyDictionary

        tlsMinimumSupportedProtocol = builder.tlsMinimumSupportedProtocol

        tlsMaximumSupportedProtocol = builder.tlsMaximumSupportedProtocol

        httpShouldUsePipelining = builder.httpShouldUsePipelining

        httpShouldSetCookies = builder.httpShouldSetCookies

        httpCookieAcceptPolicy = builder.httpCookieAcceptPolicy

        urlCredentialStorage = builder.urlCredentialStorage

        httpAdditionalHeaders = builder.httpAdditionalHeaders

        httpMaximumConnectionsPerHost = builder.httpMaximumConnectionsPerHost

        httpCookieStorage = builder.httpCookieStorage

        urlCredentialStorage = builder.urlCredentialStorage

        urlCache = builder.urlCache

        if #available(iOS 9.0, tvOS 9.0, watchOS 2.0, macOS 10.11, *) {
            shouldUseExtendedBackgroundIdleMode = builder.shouldUseExtendedBackgroundIdleMode
        }

        protocolClasses = builder.protocolClasses

        if #available(iOS 11.0, *), let multipathServiceType = URLSessionConfiguration.MultipathServiceType(rawValue: builder.multipathServiceType.rawValue) {
            self.multipathServiceType = multipathServiceType
        }
    }

    public func builder() -> Builder {
        return URLSessionConfiguration.builder(self)
    }

}
