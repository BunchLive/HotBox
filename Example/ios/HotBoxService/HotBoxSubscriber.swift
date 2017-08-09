//
//  HotBoxSubscriber.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import UIKit

@objc(HotBoxSubscriber)
class HotBoxSubscriber: UIView {
  
  var subscriberView: UIView?
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.subscriberView?.frame = self.bounds
  }
  
  func setStreamId(_ streamId: NSString) {
    guard let subscriberView = HotBoxNativeService.shared.requestSubscriberView(streamId: streamId as String) else { return }
    subscriberView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.subscriberView = subscriberView
    addSubview(subscriberView)
  }
}
