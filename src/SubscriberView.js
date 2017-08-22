import React from 'react'
import PropTypes from 'prop-types'
import { requireNativeComponent, View } from 'react-native'

class SubscriberView extends React.Component {
    static propTypes = {
        streamId: PropTypes.string.isRequired,
        ...View.propTypes
    }

    render() {
        return <HotBoxSubscriberSwift {...this.props} />
    }
}

export default requireNativeComponent('HotBoxSubscriberSwift', SubscriberView)