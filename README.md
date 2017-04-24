# Net

[![Twitter](https://img.shields.io/badge/contact-@intelygenz-0FABFF.svg?style=flat)](http://twitter.com/intelygenz)
[![Version](https://img.shields.io/cocoapods/v/NetClient.svg?style=flat)](http://cocoapods.org/pods/NetClient)
[![License](https://img.shields.io/cocoapods/l/NetClient.svg?style=flat)](http://cocoapods.org/pods/NetClient)
[![Platform](https://img.shields.io/cocoapods/p/NetClient.svg?style=flat)](http://cocoapods.org/pods/NetClient)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager Compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-4BC51D.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Build Status](https://travis-ci.org/intelygenz/NetClient-iOS.svg?branch=master)](https://travis-ci.org/intelygenz/NetClient-iOS)

![Net](https://raw.githubusercontent.com/intelygenz/NetClient-iOS/master/Net.png)

**Net** is a versatile HTTP networking library written in Swift 3.

## Features

- [x] URL / JSON / Property List Parameter Encoding
- [x] Upload File / Data / Stream / Multipart Form Data
- [x] Download File using Request or Resume Data
- [x] Authentication with URLCredential
- [x] Basic, Bearer and Custom Authorization Handling
- [x] Default and Custom Cache Controls
- [x] Default and Custom Content Types
- [x] Upload and Download Progress Closures with Progress
- [x] cURL Command Debug Output
- [x] Request and Response Interceptors
- [x] Asynchronous and synchronous task execution
- [x] Inference of desired response object
- [x] watchOS Compatible
- [x] tvOS Compatible
- [x] macOS Compatible

## Requirements

- iOS 8.0+ / macOS 10.9+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.1+
- Swift 3.0+

## Installation

Net is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'NetClient'
```

#### Or you can install it with [Carthage](https://github.com/Carthage/Carthage):

```ogdl
github "intelygenz/NetClient-iOS"
```

#### Or install it with [Swift Package Manager](https://swift.org/package-manager/):

```swift
dependencies: [
    .Package(url: "https://github.com/intelygenz/NetClient-iOS.git")
]
```

## Usage

Asynchronous:

```swift
import Net

let net = NetURLSession()

net.data(URL(string: "YOUR_URL")!).async { (response, error) in
    do {
        if let object: [AnyHashable: Any] = try response?.object() {
            print("Response dictionary: \(object)")
        } else if let error = error {
            print("Net error: \(error)")
        }
    } catch {
        print("Parse error: \(error)")
    }
}
```

Synchronous:

```swift
import Net

let net = NetURLSession()

do {
    let object: [AnyHashable: Any] = try net.data("YOUR_URL").sync().object()
	print("Response dictionary: \(object)")
} catch {
    print("Error: \(error)")
}
```

## Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## Authors

[alexruperez](https://github.com/alexruperez), alejandro.ruperez@intelygenz.com

## License

Net is available under the MIT license. See the LICENSE file for more info.
