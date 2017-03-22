//
//  NetResponse+HTTPURLResponse.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public extension NetResponse {

    public init(_ httpResponse: HTTPURLResponse) {
        self.init(httpResponse.url, mimeType: httpResponse.mimeType, contentLength: httpResponse.expectedContentLength, textEncoding: httpResponse.textEncodingName, filename: httpResponse.suggestedFilename, statusCode: httpResponse.statusCode, headers: httpResponse.allHeaderFields, localizedDescription: HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))
    }

}
