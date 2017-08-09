import { NativeModules, NativeEventEmitter } from 'react-native'

console.log("NATTTOS", NativeModules)
const { HotBoxService } = NativeModules

const EventEmitter = new NativeEventEmitter(HotBoxService);

class Session {
    constructor() {
        this.listening = false
        this.listeners = {}
    }

    createSession(apiKey, sessionId, token) {
        return HotBoxService.createNewSession(apiKey, sessionId, token)
    }

    disconnectAllSessions() {
        return HotBoxService.disconnectAllSessions()
    }

    requestVideoStream(streamId, on) {
        return HotBoxService.requestVideoStream(streamId, on)
    }

    requestAudioStream(streamId, on) {
        return HotBoxService.requestAudioStream(streamId, on)
    }

    requestCameraSwap(toBack) {
        return HotBoxService.requestCameraSwap(toBack)
    }

    // Initializers

    // connectToToken(token) {
    //     return HotBoxService.connectToSession(token)
    // }

    // disconnect() {
    //     return HotBoxService.disconnectFromSession()
    // }

    // // Publishers


    // initPublisher() {
    //     return HotBoxService.initPublisher()
    // }

    // publishToSession() {
    //     return HotBoxService.publishToSession()
    // }

    // publishVideo(enable) {
    //     return HotBoxService.requestVideoStream(enable)
    // }

    // publishAudio(enable) {
    //     return HotBoxService.requestAudioStream(enable)
    // }

    // setCameraPosition(position) {
    //     let isBack = position === 'back' ? true : false
    //     return HotBoxService.requestCameraChange(isBack)
    // }

    // broadcastMessage(type, message) {
    //     return this.sendMessage(type, message, null)
    // }

    // sendMessage(type, message, connectionId) {
    //     return HotBoxService.sendSigal(type, message, connectionId)
    // }

    // // Events

    on(eventName, handler) {
        if (this.listeners[eventName]) return
        this.listeners[eventName] = EventEmitter.addListener(
            eventName,
            event => handler(event)
        )
        
        if (!this.listening) this._bindSignals()
    }

    off(eventName, handler) {
        if (!this.listeners[eventName]) return

        this.listeners[eventName].remove()
        this.listeners[eventName] = null
    }

    // Subscribers

    subscribe(streamId) {
        return HotBoxService.subscribeToStream(streamId)
    }

    // unsubscribe(streamId) {
    //     return HotBoxService.unsubscribeFromStream(streamId)
    // }

    // subscribeToVideo(streamId, enable) {
    //     return HotBoxService.requestSubscriberVideoStream(streamId, enable)
    // }

    // subscribeToAudio(streamId, enable) {
    //     return HotBoxService.requestSubscriberAudioStream(streamId, enable)
    // }

    // // Internal

    _bindSignals() {
        if (!this.listening) this.listening = true
        return HotBoxService.bindSignals()
    }

}

export default Session