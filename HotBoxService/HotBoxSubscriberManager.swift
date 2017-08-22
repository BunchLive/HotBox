//
//  HotBoxSubscriberManager.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import UIKit

@objc(HotBoxSubscriberSwift)
class HotBoxSubscriberManager: RCTViewManager {
  override func view() -> UIView! {
    return HotBoxSubscriber()
  }
}
