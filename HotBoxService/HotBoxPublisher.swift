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
  var talkBorderWidth : CGFloat = 3
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    guard let publisherView = HotBoxNativeService.shared.requestPublisherView() else { return }
    if let publisher = HotBoxNativeService.shared.publisher {
      publisher.audioLevelDelegate = self
    }
    publisherView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.publisherView = publisherView
    addSubview(publisherView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let borderWidth = talkBorderWidth
    self.publisherView?.frame = self.bounds.insetBy(dx: borderWidth, dy: borderWidth)
    self.publisherView?.layer.cornerRadius = max(1, self.layer.cornerRadius - talkBorderWidth)
    self.publisherView?.clipsToBounds = true
  }
  
  deinit {
    if let publisher = HotBoxNativeService.shared.publisher {
      if publisher.audioLevelDelegate === self {
        publisher.audioLevelDelegate = nil
      }
    }
  }
}

extension HotBoxPublisher : OTPublisherKitAudioLevelDelegate {
  func publisher(_ publisher: OTPublisherKit, audioLevelUpdated audioLevel: Float) {
    let alpha = CGFloat(audioLevel * 2)
    self.layer.borderColor = UIColor.white.withAlphaComponent(alpha).cgColor
    self.layer.borderWidth = talkBorderWidth
  }
}
