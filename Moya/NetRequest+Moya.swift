//
//  NetRequest+Moya.swift
//  Net
//
//  Created by Alex Rupérez on 24/4/17.
//
//

import Moya
import Alamofire

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
            return Alamofire.HTTPMethod.get
        case .POST:
            return Alamofire.HTTPMethod.post
        case .PUT:
            return Alamofire.HTTPMethod.put
        case .DELETE:
            return Alamofire.HTTPMethod.delete
        case .PATCH:
            return Alamofire.HTTPMethod.patch
        case .HEAD:
            return Alamofire.HTTPMethod.head
        case .TRACE:
            return Alamofire.HTTPMethod.trace
        case .OPTIONS:
            return Alamofire.HTTPMethod.options
        case .CONNECT:
            return Alamofire.HTTPMethod.connect
        default:
            return Alamofire.HTTPMethod.get
        }
    }

    public var parameters: [String: Any]? {
        do {
            return try NetTransformer.object(object: body)
        } catch {
            return nil
        }
    }

    public var parameterEncoding: Moya.ParameterEncoding {
        guard let parameterEncoding = contentType else {
            return Alamofire.URLEncoding.default
        }
        switch parameterEncoding {
        case .json:
            return Alamofire.JSONEncoding.default
        case .plist:
            return Alamofire.PropertyListEncoding.default
        default:
            return Alamofire.URLEncoding.default
        }
    }

    public var sampleData: Data {
        return body ?? Data()
    }

    public var task: Task {
        return Moya.Task.requestPlain
    }
}
