# RxPushKit

[![CI Status](https://img.shields.io/travis/pawelrup/RxPushKit.svg?style=flat)](https://travis-ci.org/pawelrup/RxPushKit)
[![Version](https://img.shields.io/cocoapods/v/RxPushKit.svg?style=flat)](https://cocoapods.org/pods/RxPushKit)
[![License](https://img.shields.io/cocoapods/l/RxPushKit.svg?style=flat)](https://cocoapods.org/pods/RxPushKit)
[![Platform](https://img.shields.io/cocoapods/p/RxPushKit.svg?style=flat)](https://cocoapods.org/pods/RxPushKit)
[![Xcode](https://img.shields.io/badge/Xcode-12.0-lightgray.svg?style=flat&logo=xcode)](https://itunes.apple.com/pl/app/xcode/id497799835)
[![Swift 5.3](https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat&logo=swift)](https://swift.org/)

## Requirements

Xcode 12, Swift 5.3

## Installation

### Swift Package Manager

RxUserNotifications is available through Swift Package Manager. To install it, add the following line to your `Package.swift` into dependencies:
```swift
.package(url: "https://github.com/pawelrup/RxPushKit", .upToNextMinor(from: "1.1.0"))
```
and then add `RxPushKit` to your target dependencies.

### CocoaPods

RxPushKit is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RxPushKit'
```

## Usage

Create your push registry with desired push types:

```swift
let pushRegistry = PKPushRegistry(queue: .main)
pushRegistry.desiredPushTypes = [.voIP]
```

Subscribe for a push token:

```swift
// Receiving push token
voipPushRegistry.rx.didUpdateCredentials
	.map { ($0.pushCredentials.token.map { String(format: "%02x", $0) }.joined(), $0.type) }
	.subscribe(onNext: { (token: String, type: PKPushType) in
		switch type {
		case .voIP:
			// Register VoIP push token (a property of PKPushCredentials) with server
			print("PushKit voIP token:", token)
		default:
			// Register other tokens if you wan to
			break
		}
	})
	.disposed(by: disposeBag)

// Invalidating push token
voipPushRegistry.rx.didInvalidatePushToken
	.subscribe(onNext: { (type: PKPushType) in
		print(#function, type)
	})
	.disposed(by: disposeBag)
```

To receive a push subscribe `didReceiveIncomingPushWithCompletion` when iOS 11 or later, or `didReceiveIncomingPush` for earlier verions.

```swift
if #available(iOS 11, *) {
    voipPushRegistry.rx.didReceiveIncomingPushWithCompletion
        .subscribe(onNext: { (payload: PKPushPayload, type: PKPushType, completion: @escaping () -> Void) in
            print(#line, payload.dictionaryPayload, type)
            completion()
        })
        .disposed(by: disposeBag)
} else {
    voipPushRegistry.rx.didReceiveIncomingPush
        .subscribe(onNext: { (payload: PKPushPayload, type: PKPushType) in
            print(#line, payload.dictionaryPayload, type)
        })
        .disposed(by: disposeBag)
}
```

You can see usage of `RxPushKit` in example.

## Author

lobocode, pawelrup@lobocode.pl

## License

RxPushKit is available under the MIT license. See the LICENSE file for more info.
