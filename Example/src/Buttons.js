import React, { Component } from "react";
import {
  Text,
  View,
  Image,
  Dimensions,
  StyleSheet,
  TouchableOpacity,
  TextInput
} from "react-native";

const { width, height } = Dimensions.get("window");

import BarButton from './components/BarButton'
import FooterView from "./components/FooterView";

import * as icons from './assets'

const Footer = ({
    publishingAudio,
    publishingVideo,
    publishingVideoTouch,
    publishingAudioTouch,

    touchMiddle
}) => {

  leftTouch = () => {
      console.log("touch")
  }

  return (
    <FooterView style={styles.FooterStyle}>
      <BarButton>
        <TouchableOpacity
          style={styles.leftButton}
          onPress={publishingVideoTouch}
          activeOpacity={1.0}
        >
          <Image
            style={{ height: 19, width: 32, resizeMode: "contain", flex: 1 }}
            source={publishingVideo? icons.VideoImage : icons.VideoOffImage}
          />
        </TouchableOpacity>
      </BarButton>
      <BarButton>
        <TouchableOpacity
          style={styles.centerButton}
          onPress={touchMiddle}
          activeOpacity={1.0}
        >
          <Image
            style={{ height: 24, width: 24, resizeMode: "contain", flex: 1 }}
            source={icons.MicImage}
          />
        </TouchableOpacity>
      </BarButton>
      <BarButton>
        <TouchableOpacity
          style={styles.rightButton}
          onPress={publishingAudioTouch}
          activeOpacity={1.0}
        >
          <Image
            style={{ height: 24, width: 24, resizeMode: "contain", flex: 1 }}
            source={publishingAudio ? icons.MicImage: icons.MicOffImage}
          />
        </TouchableOpacity>
      </BarButton>
    </FooterView>
  );
};

const styles = StyleSheet.create({
  FooterStyle: {
    backgroundColor: "transparent",
    position: "absolute",
    left: 0,
    width,
    height: 86
  },
  leftButton: {
    height: 19,
    width: 32
  },
  centerButton: {
    height: 24,
    width: 24,
    shadowColor: "black",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    shadowRadius: 2
  },
  rightButton: {
    height: 24,
    width: 24,
    shadowColor: "black",
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.2,
    shadowRadius: 2
  }
});

export default Footer