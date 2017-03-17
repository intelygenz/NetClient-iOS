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

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let date = Date()
            print(try NetURLSession.shared.json("http://www.alexruperez.com/home.json") ?? "No data!")
            print("Time: \(Date().timeIntervalSince(date))")
        } catch {
            print("Error: \(error)")
        }
    }

}
