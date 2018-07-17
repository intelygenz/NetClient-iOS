//
//  NetResponse+Rx.swift
//  Net
//
//  Created by Alejandro Ruperez Hernando on 20/12/17.
//

import Foundation
import RxSwift

extension ObservableType where E == NetResponse {

    public func object<T>() throws -> Observable<T> {
        return flatMap {
            return Observable.just(try $0.object())
        }
    }

    public func decode<D: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                     dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                     nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
                                     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                     userInfo: [CodingUserInfoKey : Any] = [:]) -> Observable<D> {
        return flatMap {
            return Observable.just(try $0.decode(dateDecodingStrategy: dateDecodingStrategy,
                                                 dataDecodingStrategy: dataDecodingStrategy,
                                                 nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                                                 keyDecodingStrategy: keyDecodingStrategy,
                                                 userInfo: userInfo))
        }
    }

}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == NetResponse {

    public func object<T>() throws -> Single<T> {
        return flatMap {
            return Single.just(try $0.object())
        }
    }

    public func decode<D: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                     dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
                                     nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw,
                                     keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                     userInfo: [CodingUserInfoKey : Any] = [:]) -> Single<D> {
        return flatMap {
            return Single.just(try $0.decode(dateDecodingStrategy: dateDecodingStrategy,
                                             dataDecodingStrategy: dataDecodingStrategy,
                                             nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
                                             keyDecodingStrategy: keyDecodingStrategy,
                                             userInfo: userInfo))
        }
    }

}
