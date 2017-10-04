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
  var subscriberStreamId: NSString?
  var subscriberBorderWidth: CGFloat = 0
  var subscriberUseAlpha = false
  var subscriberAlphaTimer: CGFloat = 5
  var subscriberAlphaTransition: CGFloat = 0.5
  var subscriberTalkingAlphaThreshold: CGFloat = 0.5
  var subscriberMaxAlpha: CGFloat = 0.7
  var subscriberMinAlpha: CGFloat = 0.3
  var maxVolumeLevel: Float = 0.0001
  var timer: Timer?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    subscriberView?.frame = bounds.insetBy(dx: subscriberBorderWidth, dy: subscriberBorderWidth)
    subscriberView?.layer.cornerRadius = max(1, layer.cornerRadius - subscriberBorderWidth)
    subscriberView?.clipsToBounds = true
  }
  
  func setStreamId(_ streamId: NSString) {
    guard let subscriber = HotBoxNativeService.shared.subscribers[streamId as String], let subscriberView = HotBoxNativeService.shared.requestSubscriberView(streamId: streamId as String) else { return }
    subscriberStreamId = streamId
    subscriber?.audioLevelDelegate = self
    subscriberView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.subscriberView = subscriberView
    addSubview(subscriberView)
  }
  
  func setTalkingBorderWidth(_ borderWidth: CGFloat) {
    subscriberBorderWidth = borderWidth
    layoutSubviews()
  }
  
  func setUseAlpha(_ useAlpha: Bool) {
    subscriberUseAlpha = useAlpha
  }
  
  func setAlphaTimer(_ alphaTimer: CGFloat) {
    subscriberAlphaTimer = alphaTimer
  }
  
  func setAlphaTransition(_ alphaTransition: CGFloat) {
    subscriberAlphaTransition = alphaTransition
  }
  
  func setTalkingAlphaThreshold(_ talkingAlphaThreshold: CGFloat) {
    subscriberTalkingAlphaThreshold = talkingAlphaThreshold
  }
  
  func setMaxAlpha(_ maxAlpha: CGFloat) {
    subscriberMaxAlpha = maxAlpha
  }
  
  func setMinAlpha(_ minAlpha: CGFloat) {
    subscriberMinAlpha = minAlpha
  }
  
  deinit {
    timer?.invalidate()
    guard let subscriberStreamId = self.subscriberStreamId, let subscriber = HotBoxNativeService.shared.subscribers[subscriberStreamId as String] else { return }
    if subscriber?.audioLevelDelegate === self {
      subscriber?.audioLevelDelegate = nil
    }
  }
}

extension HotBoxSubscriber: OTSubscriberKitAudioLevelDelegate {
  
  func setInactiveAlpha() {
    UIView.animate(withDuration: TimeInterval(subscriberAlphaTransition), delay: 0, options: .allowUserInteraction, animations: {
      self.alpha = self.subscriberMinAlpha
    })
  }
  
  func subscriber(_ subscriber: OTSubscriberKit, audioLevelUpdated audioLevel: Float) {
    if subscriber.stream?.hasAudio == true {
      maxVolumeLevel = max(audioLevel, maxVolumeLevel)
      
      let alpha = CGFloat(audioLevel / maxVolumeLevel * 10)

      if subscriberBorderWidth > 0 {
        layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
        layer.borderWidth = subscriberBorderWidth
      }
      
      if subscriberUseAlpha && alpha > subscriberTalkingAlphaThreshold {
        UIView.animate(withDuration: TimeInterval(subscriberAlphaTransition), delay: 0, options: .allowUserInteraction, animations: {
          self.alpha = self.subscriberMaxAlpha
        })
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(subscriberAlphaTimer), target: self, selector: #selector(setInactiveAlpha), userInfo: nil, repeats: false)
      }
    }
  }
}
