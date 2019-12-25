import React from 'react';
import { ApolloClient, ApolloProvider, HttpLink, InMemoryCache, split, getMainDefinition } from '@apollo/client';
import { createAppContainer } from 'react-navigation';
import { createBottomTabNavigator } from 'react-navigation-tabs';
import { Icon, colors } from 'react-native-elements';
import { Listings } from './components/listings';
import { Monitors } from './components/monitors';
import { WebSocketLink } from 'apollo-link-ws';

const httpLink = new HttpLink({
  uri: 'http://192.168.1.199:5000',
});

const wsLink = new WebSocketLink({
  uri: 'ws://192.168.1.199:5000',
  options: {
    reconnect: true,
    reconnectionAttempts: 5
  }
});

const link = split(({ query }) => {
  const definition = getMainDefinition(query);
  return (
    definition.kind === 'OperationDefinition' &&
    definition.operation === 'subscription'
  );
},
  wsLink,
  httpLink,
);

const apollo = new ApolloClient({
  cache: new InMemoryCache(),
  link: link
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
