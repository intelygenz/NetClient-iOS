//
//  NetTask+RxSwift.swift
//  Net
//
//  Created by Alex Rupérez on 19/12/17.
//

import Foundation
import RxSwift

extension Reactive where Base: NetTask {
    public func response() -> Observable<NetResponse> {
        return Observable.create { observer in

            let task = self.base.async({ (response, error) in
                guard let response = response, error == nil else {
                    if let error = error {
                        observer.on(.error(error))
                    }
                    return
                }

                observer.on(.next(response))
                observer.on(.completed)
            })

            return Disposables.create(with: task.cancel)
        }
    }

    public func progress() -> Observable<Progress> {
        return Observable.create { observer in

            self.base.progress({ progress in
                observer.on(.next(progress))
                if progress.totalUnitCount > 0, progress.completedUnitCount >= progress.totalUnitCount {
                    observer.on(.completed)
                }
            })

            return Disposables.create()
        }
    }
}

extension NetTask: ReactiveCompatible {}
