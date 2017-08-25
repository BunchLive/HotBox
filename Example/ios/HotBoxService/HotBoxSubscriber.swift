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
  var streamId: NSString?
  var borderWidth: CGFloat = 2
  var maxVolumeLevel: Float = 0.0001
  
  override func layoutSubviews() {
    super.layoutSubviews()
    subscriberView?.frame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
    subscriberView?.layer.cornerRadius = max(1, layer.cornerRadius - borderWidth)
    subscriberView?.clipsToBounds = true
  }
  
  func setStreamId(_ streamId: NSString) {
    guard let subscriber = HotBoxNativeService.shared.subscribers[streamId as String], let subscriberView = HotBoxNativeService.shared.requestSubscriberView(streamId: streamId as String) else { return }
    self.streamId = streamId
    subscriber.audioLevelDelegate = self
    subscriberView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.subscriberView = subscriberView
    addSubview(subscriberView)
  }

  func setBorderWidth(_ borderWidth: CGFloat) {
    self.borderWidth = borderWidth
    layoutSubviews()
  }

  deinit {
    guard let streamId = self.streamId, let subscriber = HotBoxNativeService.shared.subscribers[streamId as String] else { return }
    subscriber.audioLevelDelegate = nil
  }
}

extension HotBoxSubscriber: OTSubscriberKitAudioLevelDelegate {
  func subscriber(_ subscriber: OTSubscriberKit, audioLevelUpdated audioLevel: Float) {
    maxVolumeLevel = max(audioLevel, maxVolumeLevel)

    let alpha = CGFloat(audioLevel / maxVolumeLevel * 10)
    layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
    layer.borderWidth = talkBorderWidth
  }
}