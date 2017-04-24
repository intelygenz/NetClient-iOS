//
//  ViewController.swift
//  Example
//
//  Created by Alex Rupérez on 16/3/17.
//
//

import UIKit
import Net

class ViewController: UIViewController {

    let net = NetURLSession()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Asynchronous
        net.data(URL(string: "http://www.alexruperez.com/home.json")!).async { (response, error) in
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
            let object: [AnyHashable: Any] = try net.data("http://www.alexruperez.com/home.json").sync().object()
            print(type(of: object))
            print("Time: \(Date().timeIntervalSince(date))")
        } catch {
            print("Error: \((error as! NetError).localizedDescription)")
        }
    }

}
