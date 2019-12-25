import React from 'react';
import { ApolloClient, ApolloProvider, HttpLink, InMemoryCache } from '@apollo/client';
import { createAppContainer } from 'react-navigation';
import { createBottomTabNavigator } from 'react-navigation-tabs';
import { Icon, colors } from 'react-native-elements';
import { Listings } from './components/listings';
import { Monitors } from './components/monitors';

const apollo = new ApolloClient({
  cache: new InMemoryCache(),
  link: new HttpLink({
    uri: 'http://localhost:5000',
  })
});

const iconMap = {
  'Listings': 'ios-list',
  'Monitors': 'ios-search'
}

const AppNavigator = createBottomTabNavigator(
  {
    Listings: {
      screen: Listings,
    },
    Monitors: {
      screen: Monitors
    }
  },
  {
    initialRouteName: 'Listings',
    defaultNavigationOptions: ({ navigation }) => ({
      tabBarIcon: ({ focused }) => {
        const { routeName } = navigation.state;

        return (
          <Icon
            name={iconMap[routeName]}
            color={focused ? colors.primary : colors.greyOutline}
            type='ionicon'
            size={25}
          />
        );
      }
    })
  }
);

const AppContainer = createAppContainer(AppNavigator);

export default function App() {
  return (
    <ApolloProvider client={apollo}>
      <AppContainer />
    </ApolloProvider>
  );
}
