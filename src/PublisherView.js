import React from 'react';
import PropTypes from 'prop-types'
import  { requireNativeComponent, View } from 'react-native';

class PublisherView extends React.Component {
    static propTypes = {
        borderWidth: PropTypes.number,
        useAlpha: PropTypes.number,
        ...View.propTypes
    }
  render() {
    return <HotBoxPublisherSwift {...this.props} />;
  }
}


export default requireNativeComponent('HotBoxPublisherSwift', PublisherView);