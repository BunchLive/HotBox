//
//  HotBoxSubscriber.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import UIKit
import OpenTok

@objc(HotBoxSubscriber)
class HotBoxSubscriber: UIView {
  
  var subscriberView: UIView?
  var myStreamId: NSString?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let borderWidth = self.layer.borderWidth
    self.subscriberView?.frame = self.bounds.insetBy(dx: borderWidth, dy: borderWidth)
  }
  
  func setStreamId(_ streamId: NSString) {
    guard let subscriberView = HotBoxNativeService.shared.requestSubscriberView(streamId: streamId as String) else { return }
    if let subscriber = HotBoxNativeService.shared.subscribers[streamId as String] {
      subscriber?.audioLevelDelegate = self
    }
    self.myStreamId = streamId
    subscriberView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.subscriberView = subscriberView
    addSubview(subscriberView)
  }
  
  deinit {
    guard let streamId = self.myStreamId else { return }
    if let subscriber = HotBoxNativeService.shared.subscribers[streamId as String] {
      if subscriber?.audioLevelDelegate === self {
        subscriber?.audioLevelDelegate = nil
      }
    }
  }
}

extension HotBoxSubscriber : OTSubscriberKitAudioLevelDelegate {
  func subscriber(_ subscriber: OTSubscriberKit, audioLevelUpdated audioLevel: Float) {
    let color = self.layer.borderColor ?? UIColor.white.cgColor
    self.layer.borderColor = color.copy(alpha: CGFloat(audioLevel))
  }
}
