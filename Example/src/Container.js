import { StackNavigator } from 'react-navigation'
import Welcome from './Welcome'
import App from './App'

const AppNavigator = StackNavigator({
    Welcome: {screen: Welcome },
    Main: {screen: App}

}, {
    headerMode: 'none',
    animationEnabled: true,
    navigationOptions: {
        tabBarVisible: false,
        gesturesEnabled: false
    }
})

export default AppNavigator