import React from 'react';
import { View } from 'react-native';
import { Header } from 'react-native-elements'

export default function Monitors(props) {
  const { routeName } = props.navigation.state;

  return (
    <View>
      <Header
        centerComponent={{
          text: routeName,
          style: { color: '#fff' }
        }}
      />
    </View>
  );
}