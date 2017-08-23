import { NativeModules, NativeEventEmitter } from 'react-native'
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

    createPublisher() {
        return HotBoxService.createPublisher()
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

    modifySubscriberStream(all, streamId, resolution, frameRate) {
        return HotBoxService.modifySubscriberStream(all, streamId, resolution, frameRate)
    }

    // // Publishers

    broadcastMessage(type, message) {
        return HotBoxService.sendSignal(type, message, null)
    }

    sendMessage(type, message, connectionId) {
        return HotBoxService.sendSignal(type, message, connectionId)
    }

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
        return HotBoxService.createSubscriber(streamId)
    }

    // // Internal

    _bindSignals() {
        if (!this.listening) this.listening = true
        return HotBoxService.bindSignals()
    }

}

export default Session