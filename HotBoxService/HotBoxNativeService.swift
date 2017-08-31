//
//  HotBoxNativeService.swift
//  hotbox
//
//  Created by George Lim on 2017-08-04.
//  Copyright © 2017 George Lim. All rights reserved.
//

import OpenTok
import RxSwift

class HotBoxNativeService: NSObject {

  class func defaultSetting() -> OTPublisherSettings {
    let settings = OTPublisherSettings()
    settings.name = UIDevice.current.name
    return settings
  }

  static let shared = HotBoxNativeService()
  
  var sessions: [String : OTSession?] = [:]
  var activeSessionId: String?
  var publisher : OTPublisher? = OTPublisher(delegate: nil,
                                             settings: HotBoxNativeService.defaultSetting())
  var subscribers: [String : OTSubscriber?] = [:]
  var connections: [String : OTConnection?] = [:]
  
  let sessionDidConnect = Variable<String?>(nil)
  let sessionDidDisconnect = Variable<String?>(nil)
  let sessionConnectionCreated = Variable<[String : Any?]>([:])
  let sessionConnectionDestroyed = Variable<String?>(nil)
  let sessionStreamCreated = Variable<[String : Any?]>([:])
  let sessionStreamDidFailWithError = Variable<String?>(nil)
  let sessionStreamDestroyed = Variable<String?>(nil)
  let sessionReceivedSignal = Variable<[String : String?]>([:])
  
  let publisherStreamCreated = Variable<String?>(nil)
  let publisherStreamDidFailWithError = Variable<String?>(nil)
  let publisherStreamDestroyed = Variable<String?>(nil)
  
  let subscriberDidConnect = Variable<String?>(nil)
  let subscriberDidFailWithError = Variable<String?>(nil)
  let subscriberDidDisconnect = Variable<String?>(nil)
  let subscriberVideoEnabled = Variable<String?>(nil)
  let subscriberVideoDisabled = Variable<String?>(nil)
  
  func disconnectAllSessions(response: AutoreleasingUnsafeMutablePointer<OTError?>? = nil) -> Bool {
    var error: OTError?
    var didSucceed = true
    
    for (_, session) in sessions {
      session?.disconnect(&error)
      
      if let error = error {
        response?.pointee = error
        didSucceed = false
      }
    }
    
    return didSucceed
  }
  
  func createNewSession(apiKey: String, sessionId: String, token: String, response: AutoreleasingUnsafeMutablePointer<OTError?>? = nil) -> Bool {
    _ = disconnectAllSessions()
    
    let session = OTSession(apiKey: apiKey, sessionId: sessionId, delegate: self)
    
    var error: OTError?
    session?.connect(withToken: token, error: &error)
    
    if let error = error {
      response?.pointee = error
      return false
    }
    
    sessions[sessionId] = session
    activeSessionId = sessionId
    return true
  }
  
  func createPublisher(response: AutoreleasingUnsafeMutablePointer<OTError?>? = nil) -> Bool {
    guard let activeSessionId = activeSessionId, let activeSession = sessions[activeSessionId] else { return false }
    guard let publisher = self.publisher else { return false}
    publisher.delegate = self
    var error: OTError?
    activeSession?.publish(publisher, error: &error)
    
    if let error = error {
      response?.pointee = error
      return false
    }
    return true
  }
  
  func createSubscriber(streamId: String, response: AutoreleasingUnsafeMutablePointer<OTError?>? = nil) -> Bool {
    guard let activeSessionId = activeSessionId, let activeSession = sessions[activeSessionId], let stream = activeSession?.streams[streamId], let subscriber = OTSubscriber(stream: stream, delegate: self) else { return false }
    
    var error: OTError?
    activeSession?.subscribe(subscriber, error: &error)
    
    if let error = error {
      response?.pointee = error
      return false
    }
    
    subscribers[streamId] = subscriber
    return true
  }
  
  func requestPublisherView() -> UIView? {
    return publisher?.view
  }
  
  func requestSubscriberView(streamId: String) -> UIView? {
    return subscribers[streamId]??.view
  }
  
  func modifySubscriberStream(streamIds: [String], resolution: CGSize? = nil, frameRate: Float? = nil) -> Bool {
    var streamList: [String] = []
    
    if streamIds.count == 0 {
      for (_, item) in subscribers.enumerated() {
        if let streamId = item.value?.stream?.streamId {
          streamList.append(streamId)
        }
      }
    } else {
      streamList = streamIds
    }
    
    for streamId in streamList {
      if let subscriber = subscribers[streamId] {
        if let resolution = resolution {
          subscriber?.preferredResolution = resolution
        }
        
        if let frameRate = frameRate {
          subscriber?.preferredFrameRate = frameRate
        }
      }
    }
    
    return true
  }
  
  func sendSignal(type: String?, string: String?, to connectionId: String?, response: AutoreleasingUnsafeMutablePointer<OTError?>? = nil) -> Bool {
    guard let activeSessionId = activeSessionId, let activeSession = sessions[activeSessionId] else { return false }
    
    let connection: OTConnection?
    
    if let connectionId = connectionId, let destination = connections[connectionId] {
      connection = destination
    } else {
      connection = nil
    }
    
    var error: OTError?
    activeSession?.signal(withType: type, string: string, connection: connection, error: &error)
    
    if let error = error {
      response?.pointee = error
      return false
    }
    
    return true
  }
  
  func requestVideoStream(for streamId: String? = nil, on: Bool) -> Bool {
    if let streamId = streamId, let subscriber = subscribers[streamId] {
      subscriber?.subscribeToVideo = on
    } else if let publisher = publisher {
      publisher.publishVideo = on
    } else {
      return false
    }
    
    return true
  }
  
  func requestAudioStream(for streamId: String? = nil, on: Bool) -> Bool {
    if let streamId = streamId, let subscriber = subscribers[streamId] {
      subscriber?.subscribeToAudio = on
    } else if let publisher = publisher {
      publisher.publishAudio = on
    } else {
      return false
    }
    
    return true
  }
  
  func requestCameraSwap(toBack: Bool) -> Bool {
    guard let publisher = publisher else { return false }
    publisher.cameraPosition = (toBack ? .back : .front)
    return true
  }
}

extension HotBoxNativeService: OTSessionDelegate {
  
  func sessionDidConnect(_ session: OTSession) {
    guard session.sessionId == activeSessionId else { return }
    _ = createPublisher() // Handled by HotBox (default).
    sessionDidConnect.value = session.sessionId
  }
  
  func sessionDidDisconnect(_ session: OTSession) {
    guard session.sessionId == activeSessionId else { return }
    sessions.removeValue(forKey: session.sessionId)
    sessionDidDisconnect.value = session.sessionId
  }
  
  func session(_ session: OTSession, connectionCreated connection: OTConnection) {
    guard session.sessionId == activeSessionId else { return }
    connections[connection.connectionId] = connection
    sessionConnectionCreated.value = [
      "connectionId" : connection.connectionId,
      "creationTime" : connection.creationTime,
      "data" : connection.data
    ]
  }
  
  func session(_ session: OTSession, connectionDestroyed connection: OTConnection) {
    guard session.sessionId == activeSessionId else { return }
    connections.removeValue(forKey: connection.connectionId)
    sessionConnectionDestroyed.value = connection.connectionId
  }
  
  func session(_ session: OTSession, streamCreated stream: OTStream) {
    guard session.sessionId == activeSessionId else { return }
    _ = createSubscriber(streamId: stream.streamId) // Handled by HotBox (default).
    sessionStreamCreated.value = [
      "streamId" : stream.streamId,
      "creationTime" : stream.creationTime.timeIntervalSince1970,
      "hasAudio" : stream.hasAudio,
      "hasVideo" : stream.hasVideo,
      "name" : stream.name,
      "videoDimensions" : ["width" : stream.videoDimensions.width, "height" : stream.videoDimensions.height],
      "videoType" : (stream.videoType == .camera ? "camera" : "screen")
    ]
  }
  
  func session(_ session: OTSession, didFailWithError error: OTError) {
    guard session.sessionId == activeSessionId else { return }
    sessionStreamDidFailWithError.value = error.localizedDescription
  }
  
  func session(_ session: OTSession, streamDestroyed stream: OTStream) {
    guard session.sessionId == activeSessionId else { return }
    sessionStreamDestroyed.value = stream.streamId
  }
  
  func session(_ session: OTSession, receivedSignalType type: String?, from connection: OTConnection?, with string: String?) {
    guard session.sessionId == activeSessionId else { return }
    sessionReceivedSignal.value = ["type" : type, "connectionId" : connection?.connectionId, "string" : string]
  }
}

extension HotBoxNativeService: OTPublisherDelegate {
  
  func publisher(_ publisher: OTPublisherKit, streamCreated stream: OTStream) {
    publisherStreamCreated.value = stream.streamId
  }
  
  func publisher(_ publisher: OTPublisherKit, didFailWithError error: OTError) {
    publisherStreamDidFailWithError.value = error.localizedDescription
  }
  
  func publisher(_ publisher: OTPublisherKit, streamDestroyed stream: OTStream) {
    publisherStreamDestroyed.value = stream.streamId
  }
}

extension HotBoxNativeService: OTSubscriberDelegate {
  
  func subscriberDidConnect(toStream subscriber: OTSubscriberKit) {
    subscriberDidConnect.value = subscriber.stream?.streamId
  }
  
  func subscriber(_ subscriber: OTSubscriberKit, didFailWithError error: OTError) {
    subscriberDidFailWithError.value = subscriber.stream?.streamId
  }
  
  func subscriberDidDisconnect(fromStream subscriber: OTSubscriberKit) {
    guard let streamId = subscriber.stream?.streamId else { return }
    subscribers.removeValue(forKey: streamId)
    subscriberDidDisconnect.value = streamId
  }

  func subscriberVideoEnabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
    subscriberVideoEnabled.value = subscriber.stream?.streamId
  }

  func subscriberVideoDisabled(_ subscriber: OTSubscriberKit, reason: OTSubscriberVideoEventReason) {
    subscriberVideoDisabled.value = subscriber.stream?.streamId
  }
}
