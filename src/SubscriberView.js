import React from 'react'
import PropTypes from 'prop-types'
import { requireNativeComponent, View } from 'react-native'

class SubscriberView extends React.Component {
    static propTypes = {
        streamId: PropTypes.string.isRequired,
        talkingBorderWidth: PropTypes.number,
        useAlpha: PropTypes.bool,
        alphaTimer: PropTypes.number,
        alphaTransition: PropTypes.number,
        talkingAlphaThreshold: PropTypes.number,
        maxAlpha: PropTypes.number,
        minAlpha: PropTypes.number,
        ...View.propTypes
    }

    render() {
        return <HotBoxSubscriberSwift {...this.props} />
    }
}

export default requireNativeComponent('HotBoxSubscriberSwift', SubscriberView)