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
  
  static let shared = HotBoxNativeService()
  
  var sessions: [String : OTSession?] = [:]
  var activeSessionId: String?
  var publisher: OTPublisher?
  var subscribers: [String : OTSubscriber?] = [:]
  var connections: [String : OTConnection?] = [:]
  
  let sessionDidConnect = Variable<String?>(nil)
  let sessionDidDisconnect = Variable<String?>(nil)
  let sessionConnectionCreated = Variable<String?>(nil)
  let sessionConnectionDestroyed = Variable<String?>(nil)
  let sessionStreamCreated = Variable<String?>(nil)
  let sessionStreamDidFailWithError = Variable<String?>(nil)
  let sessionStreamDestroyed = Variable<String?>(nil)
  let sessionReceivedSignal = Variable<[String : String?]>([:])
  
  let publisherStreamCreated = Variable<String?>(nil)
  let publisherStreamDidFailWithError = Variable<String?>(nil)
  let publisherStreamDestroyed = Variable<String?>(nil)
  
  let subscriberDidConnect = Variable<String?>(nil)
  let subscriberDidFailWithError = Variable<String?>(nil)
  let subscriberDidDisconnect = Variable<String?>(nil)
  
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
    
    let settings = OTPublisherSettings()
    settings.name = UIDevice.current.name
    
    guard let publisher = OTPublisher(delegate: self, settings: settings) else { return false }
    
    var error: OTError?
    activeSession?.publish(publisher, error: &error)
    
    if let error = error {
      response?.pointee = error
      return false
    }
    
    self.publisher = publisher
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
  
  func modifySubscriberStream(all: Bool = false, forStreamId streamId: String? = nil, resolution: CGSize? = nil, frameRate: Float? = nil) -> Bool {
    if all {
      for subscriber in subscribers {
        if let resolution = resolution {
          subscriber.value?.preferredResolution = resolution
        }
        
        if let frameRate = frameRate {
          subscriber.value?.preferredFrameRate = frameRate
        }
      }
      
      return true
    } else if let streamId = streamId, let subscriber = subscribers[streamId] {
      if let resolution = resolution {
        subscriber?.preferredResolution = resolution
      }
      
      if let frameRate = frameRate {
        subscriber?.preferredFrameRate = frameRate
      }
      
      return true
    }
    
    return false
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
    sessionConnectionCreated.value = connection.connectionId
  }
  
  func session(_ session: OTSession, connectionDestroyed connection: OTConnection) {
    guard session.sessionId == activeSessionId else { return }
    connections.removeValue(forKey: connection.connectionId)
    sessionConnectionDestroyed.value = connection.connectionId
  }
  
  func session(_ session: OTSession, streamCreated stream: OTStream) {
    guard session.sessionId == activeSessionId else { return }
    _ = createSubscriber(streamId: stream.streamId) // Handled by HotBox (default).
    sessionStreamCreated.value = stream.streamId
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
}
