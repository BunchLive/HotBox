//
//  HotBoxPublisherManager.swift
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

import UIKit

@objc(HotBoxPublisherManager)
class HotBoxPublisherManager: RCTViewManager {
  override func view() -> UIView! {
    return HotBoxPublisher()
  }
}
