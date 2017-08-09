//
//  HotBoxService.m
//  hotbox
//
//  Created by George Lim on 2017-08-08.
//  Copyright © 2017 George Lim. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(HotBoxService, RCTEventEmitter)

RCT_EXTERN_METHOD(bindSignals)
RCT_EXTERN_METHOD(disconnectAllSessions:
                  (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(createNewSession:
                  (NSString*)apiKey
                  sessionId: (NSString*)sessionId
                  token: (NSString*)token
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(createPublisher:
                  (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(createSubscriber:
                  (NSString*)streamId
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(sendSignal:
                  (nullable NSString*)type
                  string: (nullable NSString*)string
                  to: (NSString)connectionId
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(requestVideoStream:
                  (nullable NSString*)streamId
                  on: (BOOL)on
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(requestAudioStream:
                  (nullable NSString*)streamId
                  on: (BOOL)on
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(requestCameraSwap:
                  (BOOL)toBack
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
@end
