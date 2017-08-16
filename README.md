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
- [x] Inference of response object type
- [x] Network reachability
- [x] TLS Certificate and Public Key Pinning
- [x] Retry requests
- [x] watchOS Compatible
- [x] tvOS Compatible
- [x] macOS Compatible
- [x] [Alamofire](https://github.com/Alamofire/Alamofire) Implementation
- [x] [Moya](https://github.com/Moya/Moya)Provider Compatible

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

### Build a NetRequest

```swift
let request = NetRequest.builder("YOUR_URL")!
            .setAccept(.json)
            .setCache(.reloadIgnoringLocalCacheData)
            .setMethod(.PATCH)
            .setTimeout(20)
            .setJSONBody(["foo", "bar"])
            .setContentType(.json)
            .setServiceType(.background)
            .setCacheControls([.maxAge(500)])
            .setURLParameters(["foo": "bar"])
            .setAcceptEncodings([.gzip, .deflate])
            .setBasicAuthorization(user: "user", password: "password")
            .setHeaders(["foo": "bar"])
            .build()
```

### Request asynchronously

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

### Request synchronously

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

### Request from cache

```swift
import Net

let net = NetURLSession()

do {
    let object: [AnyHashable: Any] = try net.data("YOUR_URL").cached().object()
    print("Response dictionary: \(object)")
} catch {
    print("Error: \(error)")
}
```

### Track progress

```swift
import Net

let net = NetURLSession()

do {
    let task = try net.data("YOUR_URL").progress({ progress in
        print(progress)
    }).sync()
} catch {
    print("Error: \(error)")
}
```

### Add interceptors for all requests

```swift
import Net

let net = NetURLSession()

net.addRequestInterceptor { request in
    request.addHeader("foo", value: "bar")
    request.setBearerAuthorization(token: "token")
    return request
}
```

### Retry requests

```swift
import Net

let net = NetURLSession()

net.retryClosure = { response, _, _ in response?.statusCode == XXX }

do {
    let task = try net.data("YOUR_URL").retry({ response, error, retryCount in
        return retryCount < 2
    }).sync()
} catch {
    print("Error: \(error)")
}
```

### Love [Alamofire](https://github.com/Alamofire/Alamofire)?

```ruby
pod 'NetClient/Alamofire'
```

```swift
import Net

let net = NetAlamofire()

...
```

### Love [Moya](https://github.com/Moya/Moya)?

```ruby
pod 'NetClient/Moya'
```

```swift
import Net
import Moya

let request = NetRequest("YOUR_URL")!
let provider = MoyaProvider<NetRequest>()
provider.request(request) { result in
    switch result {
    case let .success(response):
        print("Response: \(response)")
    case let .failure(error):
        print("Error: \(error)")
    }
}
```

## Etc.

* Contributions are very welcome.
* Attribution is appreciated (let's spread the word!), but not mandatory.

## Authors

[alexruperez](https://github.com/alexruperez), alejandro.ruperez@intelygenz.com

## License

Net is available under the MIT license. See the LICENSE file for more info.
