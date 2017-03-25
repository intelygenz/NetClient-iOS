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
        do {
            let date = Date()
            let object: [AnyHashable: Any] = try net.data("http://www.alexruperez.com/home.json").object()
            print(type(of: object))
            print("Time: \(Date().timeIntervalSince(date))")
        } catch {
            print("Error: \((error as! NetError).localizedDescription)")
        }
    }

}
