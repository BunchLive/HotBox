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
  var maxVolumeLevel: Float = 0.0001
  
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
    self.publisherBorderWidth = borderWidth
    layoutSubviews()
  }

  deinit {
    guard let publisher = HotBoxNativeService.shared.publisher else { return }
    publisher.audioLevelDelegate = nil
  }
}

extension HotBoxPublisher: OTPublisherKitAudioLevelDelegate {
  func publisher(_ publisher: OTPublisherKit, audioLevelUpdated audioLevel: Float) {
    if publisher.stream?.hasAudio == true {
      maxVolumeLevel = max(audioLevel, maxVolumeLevel)
      
      let alpha = CGFloat(audioLevel / maxVolumeLevel * 10)
      layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
      layer.borderWidth = publisherBorderWidth
    }
  }
}
