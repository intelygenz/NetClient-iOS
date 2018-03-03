//
//  ViewController.swift
//  Example
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import UIKit
import Net
import Moya
import Kommander
import RxSwift

class ViewController: UIViewController {

    let net: Net = NetURLSession.shared
    let kommander: Kommander = .default

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NetRequest("http://www.alexruperez.com/entries/3491-intelygenz-netclient-ios.json")!

        // Asynchronous
        net.data(request).async { (response, error) in
            do {
                if let object: [AnyHashable: Any] = try response?.object() {
                    print(type(of: object))
                } else if let error = error {
                    print("Net error: \(error)")
                }
            } catch {
                print("Parse error: \(error.localizedDescription)")
            }
        }

        // Synchronous
        do {
            let date = Date()
            let object: [AnyHashable: Any] = try net.data(request).sync().object()
            print(type(of: object))
            print("Time: \(Date().timeIntervalSince(date))")
        } catch {
            print("Error: \(error.localizedDescription)")
        }

        // Moya
        let provider = MoyaProvider<NetRequest>()
        provider.request(request) { result in
            switch result {
            case let .success(response):
                print(response)
            case let .failure(error):
                print(error)
            }
        }

        // Kommander
        net.data(request).execute(by: kommander, onSuccess: { object in
            print(object)
        }) { error in
            print("Error: \(String(describing: error?.localizedDescription))")
        }

        net.data(request).executeDecoding(by: kommander, onSuccess: { object in
            print(object as Article)
        }) { error in
            print("Error: \(String(describing: error?.localizedDescription))")
        }

        // Decode
        net.data(request).async { (response, error) in
            do {
                if let error = error {
                    print("Net error: \(error)")
                } else if let article: Article = try response?.decode() {
                    print(article)
                    // Encode
                    try request.builder().setJSONObject(article)
                }
            } catch {
                print("Parse error: \(error.localizedDescription)")
            }
        }

        // RxSwift
        _ = net.data(request).rx.response().observeOn(MainScheduler.instance).subscribe { print($0) }

    }

}
