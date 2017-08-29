import React from 'react';
import PropTypes from 'prop-types'
import  { requireNativeComponent, View } from 'react-native';

class PublisherView extends React.Component {
    static propTypes = {
        borderWidth: PropTypes.number,
        useAlpha: PropTypes.bool,
        alphaTimer: PropTypes.number,
        alphaTransition: PropTypes.number,
        talkingAlphaThreshold: PropTypes.number,
        maxAlpha: PropTypes.number,
        minAlpha: PropTypes.number,
        ...View.propTypes
    }
  render() {
    return <HotBoxPublisherSwift {...this.props} />;
  }
}


export default requireNativeComponent('HotBoxPublisherSwift', PublisherView);