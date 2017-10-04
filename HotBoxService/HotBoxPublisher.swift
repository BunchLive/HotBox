//
//  HotBoxPublisher.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import UIKit
import OpenTok

@objc(HotBoxPublisher)
class HotBoxPublisher: UIView {
  
  var publisherView: UIView?
  var publisherBorderWidth: CGFloat = 0
  var publisherUseAlpha = false
  var publisherAlphaTimer: CGFloat = 5
  var publisherAlphaTransition: CGFloat = 0.5
  var publisherTalkingAlphaThreshold: CGFloat = 0.5
  var publisherMaxAlpha: CGFloat = 0.7
  var publisherMinAlpha: CGFloat = 0.3
  var maxVolumeLevel: Float = 0.0001
  var timer: Timer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    guard let publisher = HotBoxNativeService.shared.publisher, let publisherView = HotBoxNativeService.shared.requestPublisherView() else { return }
    publisher.audioLevelDelegate = self
    publisherView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.publisherView = publisherView
    addSubview(publisherView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    publisherView?.frame = bounds.insetBy(dx: publisherBorderWidth, dy: publisherBorderWidth)
    publisherView?.layer.cornerRadius = max(1, layer.cornerRadius - publisherBorderWidth)
    publisherView?.clipsToBounds = true
  }

  func setBorderWidth(_ borderWidth: CGFloat) {
    publisherBorderWidth = borderWidth
    layoutSubviews()
  }
  
  func setUseAlpha(_ useAlpha: Bool) {
    publisherUseAlpha = useAlpha
  }
  
  func setAlphaTimer(_ alphaTimer: CGFloat) {
    publisherAlphaTimer = alphaTimer
  }
  
  func setAlphaTransition(_ alphaTransition: CGFloat) {
    publisherAlphaTransition = alphaTransition
  }
  
  func setTalkingAlphaThreshold(_ talkingAlphaThreshold: CGFloat) {
    publisherTalkingAlphaThreshold = talkingAlphaThreshold
  }
  
  func setMaxAlpha(_ maxAlpha: CGFloat) {
    publisherMaxAlpha = maxAlpha
  }
  
  func setMinAlpha(_ minAlpha: CGFloat) {
    publisherMinAlpha = minAlpha
  }

  deinit {
    timer?.invalidate()
    guard let publisher = HotBoxNativeService.shared.publisher else { return }
    if publisher.audioLevelDelegate === self {
      publisher.audioLevelDelegate = nil
    }
  }
}

extension HotBoxPublisher: OTPublisherKitAudioLevelDelegate {
  
  func setInactiveAlpha() {
    UIView.animate(withDuration: TimeInterval(publisherAlphaTransition), delay: 0, options: .allowUserInteraction, animations: {
      self.alpha = self.publisherMinAlpha
    })
  }
  
  func publisher(_ publisher: OTPublisherKit, audioLevelUpdated audioLevel: Float) {
    if publisher.stream?.hasAudio == true {
      maxVolumeLevel = max(audioLevel, maxVolumeLevel)
      
      let alpha = CGFloat(audioLevel / maxVolumeLevel * 10)

      if publisherBorderWidth > 0 {
        layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
        layer.borderWidth = publisherBorderWidth
      }
      
      if publisherUseAlpha && alpha > publisherTalkingAlphaThreshold {
        UIView.animate(withDuration: TimeInterval(publisherAlphaTransition), delay: 0, options: .allowUserInteraction, animations: {
          self.alpha = self.publisherMaxAlpha
        })
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(publisherAlphaTimer), target: self, selector: #selector(setInactiveAlpha), userInfo: nil, repeats: false)
      }
    }
  }
}
