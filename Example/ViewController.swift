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

class ViewController: UIViewController {

    let net: Net = NetURLSession()

    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NetRequest("http://www.alexruperez.com/home.json")!

        // Asynchronous
        net.data(request).async { (response, error) in
            do {
                if let object: [AnyHashable: Any] = try response?.object() {
                    print(type(of: object))
                } else if let error = error {
                    print("Net error: \(error)")
                }
            } catch {
                print("Parse error: \((error as! NetError).localizedDescription)")
            }
        }

        // Synchronous
        do {
            let date = Date()
            let object: [AnyHashable: Any] = try net.data(request).sync().object()
            print(type(of: object))
            print("Time: \(Date().timeIntervalSince(date))")
        } catch {
            print("Error: \((error as! NetError).localizedDescription)")
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
    }

}
