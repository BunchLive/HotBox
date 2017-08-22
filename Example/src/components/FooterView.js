import React, { Component } from 'react';
import {
  Text,
  View,
  Image,
  Dimensions,
  StyleSheet,
  TouchableOpacity,
  TextInput
} from 'react-native';

const { width, height } = Dimensions.get('window');

const FooterView = ({children}) => {
    return (
        <View style={styles.footerStyle}>
            <View style={{display: 'flex', flexDirection: 'row', justifyContent: 'space-around', alignItems: 'center'}}>
                {children}
            </View>
        </View>
    )
}

const styles = StyleSheet.create({
    footerStyle: {
        position: 'absolute',
        bottom: 0,
        width: width,
      backgroundColor: 'transparent',
      marginBottom: 25,
      marginTop: 50
    }
})

export default FooterView