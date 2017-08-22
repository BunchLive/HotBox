//
//  HotBoxService.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import Foundation
import RxSwift

enum Events: String {
  case sessionDidConnect, sessionDidDisconnect, sessionConnectionCreated, sessionConnectionDestroyed, sessionStreamCreated, sessionStreamDidFailWithError, sessionStreamDestroyed, sessionReceivedSignal, publisherStreamCreated, publisherStreamDidFailWithError, publisherStreamDestroyed, subscriberDidConnect, subscriberDidFailWithError, subscriberDidDisconnect
}

@objc(HotBoxService)
class HotBoxService: RCTEventEmitter {
  
  var disposeBag = DisposeBag()
  
  override func supportedEvents() -> [String]! {
    return [Events.sessionDidConnect.rawValue, Events.sessionDidDisconnect.rawValue, Events.sessionConnectionCreated.rawValue, Events.sessionConnectionDestroyed.rawValue, Events.sessionStreamCreated.rawValue, Events.sessionStreamDidFailWithError.rawValue, Events.sessionStreamDestroyed.rawValue, Events.sessionReceivedSignal.rawValue, Events.publisherStreamCreated.rawValue, Events.publisherStreamDidFailWithError.rawValue, Events.publisherStreamDestroyed.rawValue, Events.subscriberDidConnect.rawValue, Events.subscriberDidFailWithError.rawValue, Events.subscriberDidDisconnect.rawValue]
  }
  
  @objc func bindSignals() {
    disposeBag = DisposeBag()
    
    HotBoxNativeService.shared.sessionDidConnect.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionDidConnect.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionDidDisconnect.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionDidDisconnect.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionConnectionCreated.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionConnectionCreated.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionConnectionDestroyed.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionConnectionDestroyed.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionStreamCreated.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionStreamCreated.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionStreamDidFailWithError.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      if let signal = signal {
        self?.sendEvent(withName: Events.sessionStreamDidFailWithError.rawValue, body: signal)
        print(signal)
      }
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionStreamDestroyed.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionStreamDestroyed.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.sessionReceivedSignal.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.sessionReceivedSignal.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.publisherStreamCreated.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.publisherStreamCreated.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.publisherStreamDidFailWithError.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      if let signal = signal {
        self?.sendEvent(withName: Events.publisherStreamDidFailWithError.rawValue, body: signal)
        print(signal)
      }
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.publisherStreamDestroyed.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.publisherStreamDestroyed.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.subscriberDidConnect.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.subscriberDidConnect.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.subscriberDidFailWithError.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      if let signal = signal {
        self?.sendEvent(withName: Events.subscriberDidFailWithError.rawValue, body: signal)
        print(signal)
      }
    }).addDisposableTo(disposeBag)
    
    HotBoxNativeService.shared.subscriberDidDisconnect.asObservable().skip(1).subscribe(onNext: {
      [weak self]
      (signal) in
      self?.sendEvent(withName: Events.subscriberDidDisconnect.rawValue, body: signal)
    }).addDisposableTo(disposeBag)
  }
  
  @objc func disconnectAllSessions(resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.disconnectAllSessions() {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func createNewSession(_ apiKey: String, sessionId: String, token: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.createNewSession(apiKey: apiKey, sessionId: sessionId, token: token) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func createPublisher(resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.createPublisher() {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func createSubscriber(streamId: String, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.createSubscriber(streamId: streamId) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }

  @objc func modifySubscriberStream(all: Bool = false, forStreamId streamId: String? = nil, resolution: NSDictionary<NSString, NSNumber>? = nil, frameRate: NSNumber? = nil, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    var resolutionSize: CGSize? = nil
    
    if let resolution = resolution, let width = resolution["width"] as CGFloat, let height = resolution["height"] as CGFloat {
      resolutionSize = CGSize(width: width, height: height)
    }
    
    if HotBoxNativeService.shared.modifySubscriberStream(all: all, forStreamId: streamId, resolution: resolutionSize, frameRate: frameRate?.floatValue) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func sendSignal(type: String?, string: String?, to connectionId: String?, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.sendSignal(type: type, string: string, to: connectionId) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func requestVideoStream(_ streamId: String? = nil, on: Bool, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.requestVideoStream(for: streamId, on: on) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func requestAudioStream(_ streamId: String? = nil, on: Bool, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.requestAudioStream(for: streamId, on: on) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
  
  @objc func requestCameraSwap(_ toBack: Bool, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if HotBoxNativeService.shared.requestCameraSwap(toBack: toBack) {
      resolve(nil)
    } else {
      reject("1", "", nil)
    }
  }
}
