//
//  NetResponse+Build.swift
//  Net
//
//  Created by Alex Rupérez on 28/3/17.
//
//

import Foundation

extension NetResponse {

    public class Builder {

        public typealias BuildClosure = (Builder) -> Swift.Void

        public var url: URL?

        public var mimeType: String?

        public var contentLength: Int64

        public var textEncoding: String?

        public var filename: String?

        public var statusCode: Int?

        public var headers: [AnyHashable : Any]?

        public var localizedDescription: String?
        
        public var responseObject: Any?

        public init(_ netResponse: NetResponse? = nil, buildClosure: BuildClosure? = nil) {
            url = netResponse?.url
            mimeType = netResponse?.mimeType
            contentLength = netResponse?.contentLength ?? -1
            textEncoding = netResponse?.textEncoding
            filename = netResponse?.filename
            statusCode = netResponse?.statusCode
            headers = netResponse?.headers
            localizedDescription = netResponse?.localizedDescription
            responseObject = netResponse?.responseObject
            buildClosure?(self)
        }

        @discardableResult public func setURL(_ url: URL?) -> Self {
            self.url = url
            return self
        }

        @discardableResult public func setMimeType(_ mimeType: String?) -> Self {
            self.mimeType = mimeType
            return self
        }

        @discardableResult public func setContentLength(_ contentLength: Int64) -> Self {
            self.contentLength = contentLength
            return self
        }

        @discardableResult public func setTextEncoding(_ textEncoding: String?) -> Self {
            self.textEncoding = textEncoding
            return self
        }

        @discardableResult public func setFilename(_ filename: String?) -> Self {
            self.filename = filename
            return self
        }

        @discardableResult public func setStatusCode(_ statusCode: Int?) -> Self {
            self.statusCode = statusCode
            return self
        }

        @discardableResult public func setHeaders(_ headers: [AnyHashable : Any]?) -> Self {
            self.headers = headers
            return self
        }

        @discardableResult public func setDescription(_ localizedDescription: String?) -> Self {
            self.localizedDescription = localizedDescription
            return self
        }

        @discardableResult public func setObject(_ responseObject: Any?) -> Self {
            self.responseObject = responseObject
            return self
        }

        public func build() -> NetResponse {
            return NetResponse(self)
        }

    }

    public static func builder(_ netResponse: NetResponse?, buildClosure: Builder.BuildClosure? = nil) -> Builder {
        return Builder(netResponse, buildClosure: buildClosure)
    }

    public init(_ builder: Builder) {
        self.init(builder.url, mimeType: builder.mimeType, contentLength: builder.contentLength, textEncoding: builder.textEncoding, filename: builder.filename, statusCode: builder.statusCode, headers: builder.headers, localizedDescription: builder.localizedDescription, responseObject: builder.responseObject)
    }

    public func builder(buildClosure: Builder.BuildClosure? = nil) -> Builder {
        return NetResponse.builder(self, buildClosure: buildClosure)
    }

}
