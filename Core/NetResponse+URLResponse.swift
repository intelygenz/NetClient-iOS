//
//  NetResponse+URLResponse.swift
//  Net
//
//  Created by Alex Rupérez on 22/3/17.
//
//

import Foundation

public extension NetResponse {

    public init(_ response: URLResponse) {
        self.init(response.url, mimeType: response.mimeType, contentLength: response.expectedContentLength, textEncoding: response.textEncodingName, filename: response.suggestedFilename)
    }
    
}
