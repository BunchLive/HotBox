/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  Dimensions
} from 'react-native';

import {Session, PublisherView, SubscriberView} from 'react-native-hot-box'

var {width, height} =  Dimensions.get('window')

var session = new Session()

let apiKey = '45929062'
let sessionId = '2_MX40NTkyOTA2Mn5-MTUwMTc4Mjg4NzA1NH56aTJiQTdrdHEyT3VMRVBwQ3J0KzJMVnZ-fg'
let token = 'T1==cGFydG5lcl9pZD00NTkyOTA2MiZzaWc9ZDA0YTViZWI0NDgwNGJkYTAyYjAzMjIwMTM3NTJmOThhMDkxMzRmNzpzZXNzaW9uX2lkPTJfTVg0ME5Ua3lPVEEyTW41LU1UVXdNVGM0TWpnNE56QTFOSDU2YVRKaVFUZHJkSEV5VDNWTVJWQndRM0owS3pKTVZuWi1mZyZjcmVhdGVfdGltZT0xNTAxNzgyOTE1Jm5vbmNlPTAuOTM5NTg2NzcwNjgwNTk5MSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTA0Mzc0OTE0JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9'

export default class Example extends Component {
  state = {
    connected: false,
    subscriberIds: [],
    video: false,
    audio: false
  }

  connectRoomOne = () => {
    let apiKey = '45929062'
    let sessionId = '2_MX40NTkyOTA2Mn5-MTUwMTc4Mjg4NzA1NH56aTJiQTdrdHEyT3VMRVBwQ3J0KzJMVnZ-fg'
    let token = 'T1==cGFydG5lcl9pZD00NTkyOTA2MiZzaWc9ZDA0YTViZWI0NDgwNGJkYTAyYjAzMjIwMTM3NTJmOThhMDkxMzRmNzpzZXNzaW9uX2lkPTJfTVg0ME5Ua3lPVEEyTW41LU1UVXdNVGM0TWpnNE56QTFOSDU2YVRKaVFUZHJkSEV5VDNWTVJWQndRM0owS3pKTVZuWi1mZyZjcmVhdGVfdGltZT0xNTAxNzgyOTE1Jm5vbmNlPTAuOTM5NTg2NzcwNjgwNTk5MSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNTA0Mzc0OTE0JmluaXRpYWxfbGF5b3V0X2NsYXNzX2xpc3Q9'

    session.createSession(apiKey, sessionId, token)
  }

  connectRoomTwo = () => {
    let apiKey = '45929062'
    let sessionId = '1_MX40NTkyOTA2Mn5-MTUwMTg1NzE2MDk5NX5CaGhVVUxRMTc2U0E2L09mNDcvSnE2T0R-UH4'
    let token = 'T1==cGFydG5lcl9pZD00NTkyOTA2MiZzaWc9ODRhMjNkYTI1M2UyNjU4MTJlZTk0ZmJjY2IxNDNjMDY0YjQxNGJjNzpzZXNzaW9uX2lkPTFfTVg0ME5Ua3lPVEEyTW41LU1UVXdNVGcxTnpFMk1EazVOWDVDYUdoVlZVeFJNVGMyVTBFMkwwOW1ORGN2U25FMlQwUi1VSDQmY3JlYXRlX3RpbWU9MTUwMTg1NzE5MiZub25jZT0wLjUwMzE4MDAwNTU0NzEyODUmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUwNDQ0OTE5MCZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=='

    session.createSession(apiKey, sessionId, token)
  }

  didDisconnect = () => {
    this.setState({
      connected: false,
      subscriberIds: []
    })
  }

  didConnect = () => {
    console.log('Did connect')

    this.setState({
      connected: true,
      video: true,
      audio: true
    })
  }

  renderSubscribers = () => {
    console.log('Rendering Subscribers', this.state.subscriberIds.length)
    if (this.state.subscriberIds.length === 0) return null

    return this.state.subscriberIds.map((streamId) => {
      return <SubscriberView style={styles.viewStyle} streamId={streamId} />
    })
  }

  subscriberConnected = (streamId) => {
    console.log('SUB connected', streamId)
    this.setState(previousState => ({
        subscriberIds: [...previousState.subscriberIds, streamId]
    }));
  }

  subscriberDisconnected = (streamId) => {
    console.log('Sub Dis', streamId)

    var filtered = this.state.subscriberIds.filter((streamId) => streamId !== streamId)

    this.setState(previousState => ({
      subscriberIds: filtered
    }))
  }

  streamDestroyed = (test) => {
    console.log("DESTROYED", test)
    var filtered = this.state.subscriberIds.filter((streamId) => streamId !== streamId)

    this.setState(previousState => ({
      subscriberIds: filtered
    }))
  }

  toggleVideo = () => {
    session.requestVideoStream(null, false)
  }

  toggleScreen = () => {
    session.requestCameraSwap(true)
  }

  componentDidMount() {

    session.on('sessionDidConnect', () => this.didConnect())
    session.on("sessionDidDisconnect", () => this.didDisconnect())
    session.on('publisherStreamCreated', () => console.log("PUBLISHER CREATED"))
    session.on('sessionStreamCreated', () => console.log('sessionStreamCreated'))
    session.on('subscriberDidConnect', this.subscriberConnected)
    session.on("subscriberDidDisconnect", this.subscriberDisconnected)
    session.on('sessionStreamDestroyed', this.streamDestroyed)
  }

  press = ( ) => {
    this.setState({
      showView: true
    })
  }

  render() {

    let showTwoStyle = this.state.subscriberIds.length === 1 ? styles.twoMembersStyle : {}
    
    return (
      <View style={[styles.container, showTwoStyle]}>

        {this.renderSubscribers()}

        {this.state.connected ? <PublisherView style={styles.viewStyle} /> : null}


        <View style={styles.header}>
        <TouchableOpacity onPress={this.toggleAudio}>
          <Text style={styles.text}>MUTE</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.toggleScreen}>
          <Text style={styles.text}>SCREEN</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.toggleVideo}>
          <Text style={styles.text}>VIDEO</Text>
        </TouchableOpacity>
        </View>


        <View style={styles.footer}>
        <TouchableOpacity onPress={this.connectRoomOne}>
          <Text style={styles.text}>ONE</Text>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.connectRoomTwo}>
          <Text style={styles.text}>TWO</Text>
        </TouchableOpacity>
        </View>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  text:{
    color: 'green'
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  instructions: {
    textAlign: 'center',
    color: '#333333',
    marginBottom: 5,
  },
  header: {
    position: 'absolute',
    bottom: 40,
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: width,
    paddingBottom:20
  },
  footer: {
    position: 'absolute',
    bottom: 0,
    display: 'flex',
    flexDirection: 'row',
    justifyContent: 'space-around',
    width: width,
    paddingBottom:20
  },
  container: {
    display: "flex",
    backgroundColor: "transparent",
    flexDirection: "row",
    flexWrap: "wrap",
    alignItems: "stretch",
    alignContent: "stretch",
    height,
    width
  },
  viewStyle: {
    minWidth: width / 2,
    height: height/2,
    flexGrow: 1
  },

  twoMembersStyle: {
      flexDirection: 'column'
  },
  publisherViewStyle: {
    flex: 1
  },

  blurView: {
    position: "absolute",
    top: 0,
    width,
    height
  }
});

AppRegistry.registerComponent('Example', () => Example);
