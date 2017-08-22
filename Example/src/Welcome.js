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

import Confetti from 'react-native-confetti';

export default class WelcomeScreen extends Component {
    componentDidMount() {
        if(this._confettiView) {
           this._confettiView.startConfetti();
        }
      }
      
      componentWillUnmount ()
      {
          if (this._confettiView)
          {
              this._confettiView.stopConfetti();
          }
      }

    pressed = () => {
        const { navigate } = this.props.navigation;
        navigate('Main')
    }

    render() {

        return (
            <View style={styles.middleStyle}>
                <Confetti confettiCount={1000000} timeout={1} duration={10000} ref={(node) => this._confettiView = node}/>

                <Text style={styles.headerText}>Partyhouse</Text>

                <TouchableOpacity
                    style={styles.buttonStyle}
                    onPress={this.pressed}
                    activeOpacity={1.0}
                >
                    <Text style={styles.buttonTextStyle}>LEGO</Text>
                </TouchableOpacity>
            </View>
        )
    }
}

const styles = StyleSheet.create({
    headerText: {
        fontSize: 42,
        fontWeight: "600",
        fontFamily: "System",
        marginBottom: 40
    },
    middleStyle: {
        flex: 1,
        //   display: 'flex',
        alignItems: "center",
        justifyContent: "center",
        backgroundColor: "transparent"
        //   width,
        //   height
      },

    headerStyle: {
      marginLeft: 10,
      marginRight: 10
    },
    buttonStyle: {
        width: width - 200,
    
        // marginRight:40,
        // marginLeft:40,
        paddingTop: 20,
        paddingBottom: 20,
        backgroundColor: "#6ad531",
        height: 60,
        borderRadius: 30,
        display: "flex",
        justifyContent: "center"
      },
      buttonTextStyle: {
        textAlign: "center",
        fontSize: 22,
        fontWeight: "600",
        fontFamily: "System",
        color: "white",
        backgroundColor: "transparent"
      }
})