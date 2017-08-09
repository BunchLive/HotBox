import React from 'react';
import  { requireNativeComponent, View } from 'react-native';

class PublisherView extends React.Component {
    static propTypes = {
        ...View.propTypes
    }
  render() {
    return <HotBoxPublisherSwift {...this.props} />;
  }
}


export default requireNativeComponent('HotBoxPublisherSwift', PublisherView);