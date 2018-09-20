import PackageDescription

let package = Package(
  name: "Net",
  products: [
    .library(name: "Net", targets: ["Net"]),
  ],
  dependencies : [
    .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "4.7")),
    .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "11.0")),
    .package(url: "https://github.com/intelygenz/Kommander-iOS.git", upToNextMajor: "1.1"),
    .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "4.3"))
  ],
  exclude: ["Example", "ExampleUITests", "Pods", "Tests"],
  targets: [
    .target(name: "Net", dependencies: ["Alamofire", "Moya", "Kommander", "RxSwift"])
  ]
)
