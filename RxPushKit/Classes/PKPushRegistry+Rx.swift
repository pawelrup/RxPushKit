//
//  PKPushRegistry+Rx.swift
//  RxPushKit
//
//  Created by Pawel Rup on 28.04.2018.
//  Copyright © 2018 Pawel Rup. All rights reserved.
//

import PushKit
import RxSwift
import RxCocoa

extension PKPushRegistry: HasDelegate {
	public typealias Delegate = PKPushRegistryDelegate
	
	public typealias DidReceiveIncomingPushCompletion = @convention(block) () -> Swift.Void
	
	public typealias DidUpdateCredentialsArguments = (pushCredentials: PKPushCredentials, type: PKPushType)
	public typealias DidReceiveIncomingPushArguments = (payload: PKPushPayload, type: PKPushType)
	public typealias DidReceiveIncomingPushWithCompletionArguments = (payload: PKPushPayload, type: PKPushType, completion: DidReceiveIncomingPushCompletion)
}

private class RxPKPushRegistryDelegateProxy: DelegateProxy<PKPushRegistry, PKPushRegistryDelegate>, DelegateProxyType, PKPushRegistryDelegate {
	
	public weak private (set) var controller: PKPushRegistry?
	
	let didUpdateCredentialsSubject = PublishSubject<PKPushRegistry.DidUpdateCredentialsArguments>()
	
	public init(controller: ParentObject) {
		self.controller = controller
		super.init(parentObject: controller, delegateProxy: RxPKPushRegistryDelegateProxy.self)
	}
	
	static func registerKnownImplementations() {
		self.register { RxPKPushRegistryDelegateProxy(controller: $0) }
	}
	
	func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
		didUpdateCredentialsSubject.onNext((pushCredentials, type))
		forwardToDelegate()?.pushRegistry(registry, didUpdate: pushCredentials, for: type)
	}
}

extension Reactive where Base: PKPushRegistry {
	
	public var delegate: DelegateProxy<PKPushRegistry, PKPushRegistryDelegate> {
		return RxPKPushRegistryDelegateProxy.proxy(for: base)
	}
	
	/// This method is invoked when new credentials (including push token) have been received for the specified PKPushType.
	///
	/// Arguments:
	/// - pushCredentials:	The push credentials that can be used to send pushes to the device for the specified PKPushType.
	/// - type:				This is a PKPushType constant which is present in `registry.desiredPushTypes`.
	public var didUpdateCredentials: Observable<PKPushRegistry.DidUpdateCredentialsArguments> {
		let proxy = RxPKPushRegistryDelegateProxy.proxy(for: base)
		return proxy.didUpdateCredentialsSubject
	}
	
	/// This method is invoked when a push notification has been received for the specified PKPushType.
	///
	/// Arguments:
	/// - payload:	The push payload sent by a developer via APNS server API.
	/// - type:		This is a PKPushType constant which is present in `registry.desiredPushTypes`.
	@available(iOS, introduced: 8.0, deprecated: 11.0)
	public var didReceiveIncomingPush: Observable<PKPushRegistry.DidReceiveIncomingPushArguments> {
		return delegate.methodInvoked(#selector(PKPushRegistryDelegate.pushRegistry(_:didReceiveIncomingPushWith:for:)))
			.map { return ($0[1] as! PKPushPayload, $0[2] as! PKPushType) }
	}
	
	/// This method is invoked when a push notification has been received for the specified PKPushType.
	///
	/// Arguments:
	/// - payload:	The push payload sent by a developer via APNS server API.
	/// - type:		This is a PKPushType constant which is present in `registry.desiredPushTypes`.
	/// - completion:	This completion handler should be called to signify the completion of payload processing.
	@available(iOS 11.0, *)
	public var didReceiveIncomingPushWithCompletion: Observable<PKPushRegistry.DidReceiveIncomingPushWithCompletionArguments> {
		return delegate.methodInvoked(#selector(PKPushRegistryDelegate.pushRegistry(_:didReceiveIncomingPushWith:for:completion:)))
			.map {
				let blockPointer = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained($0[3] as AnyObject).toOpaque())
				let handler = unsafeBitCast(blockPointer, to: PKPushRegistry.DidReceiveIncomingPushCompletion.self)
				return ($0[1] as! PKPushPayload, $0[2] as! PKPushType, handler)
		}
	}
	
	/// This method is invoked if a previously provided push token is no longer valid for use. No action is necessary to rerequest registration. This feedback can be used to update an app's server to no longer send push notifications of the specified type to this device.
	///
	/// Arguments:
	/// - type:	This is a PKPushType constant which is present in `registry.desiredPushTypes`.
	public var didInvalidatePushToken: Observable<PKPushType> {
		return delegate.methodInvoked(#selector(PKPushRegistryDelegate.pushRegistry(_:didInvalidatePushTokenFor:)))
			.map { return $0[1] as! PKPushType }
	}
}
