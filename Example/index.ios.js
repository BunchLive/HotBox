import React, { Component } from 'react';

import {
  AppRegistry
} from 'react-native'

import App from './src/App'
import AppNavigator from './src/Container'

export default class Example extends Component {
  render() {
    return <AppNavigator />
  }
}

AppRegistry.registerComponent('Example', () => Example);
