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
  var publisherBorderWidth: CGFloat = 2
  var publisherUseAlpha = false
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

  deinit {
    timer?.invalidate()
    guard let publisher = HotBoxNativeService.shared.publisher else { return }
    publisher.audioLevelDelegate = nil
  }
}

extension HotBoxPublisher: OTPublisherKitAudioLevelDelegate {
  
  func setInactiveAlpha() {
    UIView.animate(withDuration: 5, delay: 0, options: .allowUserInteraction, animations: {
      self.alpha = 0.3
    })
  }
  
  func publisher(_ publisher: OTPublisherKit, audioLevelUpdated audioLevel: Float) {
    if publisher.stream?.hasAudio == true {
      maxVolumeLevel = max(audioLevel, maxVolumeLevel)
      
      let alpha = CGFloat(audioLevel / maxVolumeLevel * 10)
      layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
      layer.borderWidth = publisherBorderWidth
      
      if publisherUseAlpha && alpha > 0.5 {
        UIView.animate(withDuration: 5, delay: 0, options: .allowUserInteraction, animations: {
          self.alpha = 0.7
        })
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setInactiveAlpha), userInfo: nil, repeats: false)
      }
    }
  }
}
