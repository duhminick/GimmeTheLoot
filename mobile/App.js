import React from 'react';
import { ApolloClient, ApolloProvider, HttpLink, InMemoryCache, split, getMainDefinition } from '@apollo/client';
import { setContext } from 'apollo-link-context';
import { createAppContainer } from 'react-navigation';
import { createBottomTabNavigator } from 'react-navigation-tabs';
import { Icon, colors } from 'react-native-elements';
import { Listings } from './components/listings';
import { Monitors } from './components/monitors';
import { WebSocketLink } from 'apollo-link-ws';
import { API_HTTP, API_WS, API_PORT, TOKEN } from './config';

const httpLink = new HttpLink({
  uri: `${API_HTTP}:${API_PORT}`,
});

const wsLink = new WebSocketLink({
  uri: `${API_WS}:${API_PORT}`,
  options: {
    reconnect: true,
    reconnectionAttempts: 5
  }
});

var link = split(({ query }) => {
  const definition = getMainDefinition(query);
  return (
    definition.kind === 'OperationDefinition' &&
    definition.operation === 'subscription'
  );
},
  wsLink,
  httpLink,
);

const authLink = setContext((_, { headers }) => {
  return {
    headers: {
      ...headers,
      authorization: TOKEN ? `Bearer ${TOKEN}` : "",
    }
  }
});

if (TOKEN) {
  link = authLink.concat(link);
}

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
