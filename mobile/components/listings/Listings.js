import React from 'react';
import { View, Text, FlatList } from 'react-native';
import { Header, ListItem } from 'react-native-elements';
import { gql, useQuery } from '@apollo/client';

export default function Listings(props) {
  const { routeName } = props.navigation.state;

  const ListHeader = <Header
    placement='left'
    centerComponent={{
      text: routeName.toUpperCase(),
      style: { color: '#fff' }
    }}
  />

  return (
    <View>
      <UpdatingList ListHeaderComponent={ListHeader} />
    </View>
  );
}

const GET_ITEMS = gql`
{
  items {
    id
    name
    url
    price
    source
    date
  }
}
`;

const SUBSCRIBE_ITEMS_ADDED = gql`
subscription {
  itemAdded {
    id
    name
    url
    price
    source
    date
  }
}
`;

function UpdatingList(props) {
  const { loading, error, subscribeToMore, ...result } = useQuery(GET_ITEMS);

  if (loading) return <Text>Loading...</Text>
  if (error) return <Text>Error! {error.message}</Text>

  return (
    <List
      {...result}
      ListHeaderComponent={props.ListHeaderComponent}
      subscribeToNewItems={() => {
        subscribeToMore({
          document: SUBSCRIBE_ITEMS_ADDED,
          updateQuery: (prev, { subscriptionData }) => {
            if (!subscriptionData.data) return prev;

            const newItem = subscriptionData.data.itemAdded;

            return Object.assign({}, prev, {
              items: [newItem, ...prev.items]
            });
          }
        })
      }}
    />
  );
}

class List extends React.Component {
  componentDidMount() {
    this.props.subscribeToNewItems();
  }

  _renderItem({ item }) {
    return <ListItem
      key={item.id}
      title={item.name}
      subtitle={`${item.source} - ${new Date(item.date).toLocaleString()}`}
      badge={{
        value: item.price ? `$${item.price}` : '', containerStyle: { opacity: item.price ? 100 : 0, marginLeft: item.price ? 0 : -10 }
      }}
      bottomDivider
    />;
  }

  render() {
    return <FlatList
      ListHeaderComponent={this.props.ListHeaderComponent}
      data={this.props.data.items}
      renderItem={this._renderItem}
      keyExtractor={item => item.id.toString()}
    />;
  }
}