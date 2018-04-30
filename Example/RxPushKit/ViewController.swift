//
//  ViewController.swift
//  RxPushKit
//
//  Created by pawelrup on 04/30/2018.
//  Copyright (c) 2018 pawelrup. All rights reserved.
//

import UIKit
import PushKit
import RxSwift
import RxPushKit

class ViewController: UIViewController {

	let disposeBag = DisposeBag()
	lazy var voipPushRegistry: PKPushRegistry = {
		let pushRegistry = PKPushRegistry(queue: .main)
		pushRegistry.desiredPushTypes = [.voIP]
		return pushRegistry
	}()

    override func viewDidLoad() {
        super.viewDidLoad()
		
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
		voipPushRegistry.rx.didInvalidatePushToken
			.subscribe(onNext: { (type: PKPushType) in
				print(#function, type)
			})
			.disposed(by: disposeBag)
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
    }
}
