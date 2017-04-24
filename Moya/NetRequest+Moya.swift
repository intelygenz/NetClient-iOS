//
//  NetRequest+Moya.swift
//  Net
//
//  Created by Alex Rupérez on 24/4/17.
//
//

import Moya

extension NetRequest: TargetType {
    public var baseURL: URL {
        return url
    }

    public var path: String {
        return ""
    }

    public var method: Moya.Method {
        switch httpMethod {
        case .GET:
            return .get
        case .POST:
            return .post
        case .PUT:
            return .put
        case .DELETE:
            return .delete
        case .PATCH:
            return .patch
        case .HEAD:
            return .head
        case .TRACE:
            return .trace
        case .OPTIONS:
            return .options
        case .CONNECT:
            return .connect
        default:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        do {
            return try NetTransformer.object(object: body)
        } catch {
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        guard let parameterEncoding = contentType else {
            return URLEncoding.default
        }
        switch parameterEncoding {
        case .json:
            return JSONEncoding.default
        case .plist:
            return PropertyListEncoding.default
        default:
            return URLEncoding.default
        }
    }

    public var sampleData: Data {
        return body ?? Data()
    }

    public var task: Task {
        return .request
    }
}
