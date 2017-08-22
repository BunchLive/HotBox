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

const BarButton = ({children}) => {
    return (
        <View style={styles.headerStyle}>
            {children}
        </View>
    )
}

const styles = StyleSheet.create({
    headerStyle: {
      marginLeft: 10,
      marginRight: 10
    }
})

export default BarButton