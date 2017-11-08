# HotBox
![HOTBOX LOGO](http://i.imgur.com/495tedr.png)

[![npm](https://img.shields.io/npm/dt/react-native-hot-box.svg)](https://www.npmjs.com/package/react-native-hot-box)

HotBox is a React Native wrapper around [TokBox OpenTOK SDK](https://tokbox.com/).

I tried the other React Native OpenTOK wrappers but they did not seem to work / provide the flexibility we wanted so we created our own. 


## Installation

### iOS

1. `yarn add react-native-hot-box` or inferiorly `npm install --save react-native-hot-box`
2. Add the files under `node_modules/react-native-hot-box/HotBoxService` (In Xcode: File -> Add files to "App Name")
3. You're going to want a bridging header:

```
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>
#import <React/RCTViewManager.h>
```
4. You will also want a Podfile:

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Example' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks

  use_frameworks!

  pod 'RxSwift'
  pod 'OpenTok'

end
```

5. Investigate `Example` for a full example just in case something is missing or open a ticket.

### Android

Please open a PR :)

## Usage

Something like: 

```
import {Session, PublisherView, SubscriberView} from 'react-native-hot-box'
	
var session = new Session()

session.on('sessionDidConnect', () => console.log('connected'))
session.on("sessionDidDisconnect", () => console.log('disconnected'))
session.on('publisherStreamCreated', () => console.log("PUBLISHER CREATED"))
session.on('sessionStreamCreated', () => console.log('sessionStreamCreated'))
session.on('subscriberDidConnect', ({streamId, data}) => console.log("New subscriber", streamId))
session.on("subscriberDidDisconnect", (streamId) => console.log("Subscriber disconnected", streamId))
session.on('sessionStreamDestroyed', (streamId) => console.log("Stream destroyed", streamId))

let apiKey = ''
let sessionId = ''
let token = ''

session.createSession(apiKey, sessionId, token)
```

### Events

```
* sessionDidConnect 				(sessionId)
* sessionDidDisconnect 				(sessionId)
* sessionConnectionCreated 			(connectionId)
* sessionConnectionDestroyed			(connectionId)
* sessionStreamCreated 				(streamId)
* sessionStreamDidFailWithError 		(err)
* sessionStreamDestroyed 			(streamId)
* sessionReceivedSignal 			({type, connectionId, message})
* publisherStreamCreated 			(streamId)
* publisherStreamDidFailWithError 		(err)
* publisherStreamDestroyed 			(streamId)
* subscriberDidConnect 				({streamId, data})
* subscriberDidFailWithError 			(streamId)
* subscriberDidDisconnect 			(streamId)
```

### Methods

```
session.createSession(apiKey, sessionId, token)
session.createPublisher() // You can manually create the publisher but by default it's created automatically
session.disconnectAllSessions()
	
// Turn on/off video stream for given streamId (null for publisher)
session.requestVideoStream(streamId, on)
	
// Turn on/off audio stream for given streamId (null for publisher)
session.requestAudioStream(streamId, on)
	
// Flip publisher camera
session.requestCameraSwap(toBack) // toBack==true ==> back camera
	
//Send messages
session.sendMessage(type, message, connectionId)
session.broadcastMessage(type, message)
	
//Subscribe to Stream
session.subscribe(streamId)
	
//Subscribe to signals
session.on(event, handler)
	
```

### Views

#### Publisher

`<PublisherView style={styles.viewStyle} />`

### Subscriber

`<SubscriberView style={styles.viewStyle} streamId={streamId} />`

## Example Houseparty Clone

<img src="Example/partyhouse.gif" height="500">

To run:

1. `yarn install`
2. `cd Example/ios & pod install`
3. `open Example/ios/Example.xcworkspace`
4. Add your api key, token and session key in App.js
5. `run`


## Credits

Thanks to my team:

* @george-lim
* @jyliang


Thanks to the following projects for inspiration!

* https://github.com/callstack-io/react-native-opentok
* https://github.com/tokboxnerds/opentok-react-native

## Issues?

Feel free to open an issue, submit a PR or email jordan@500labs.com to give feedback / suggestions.
