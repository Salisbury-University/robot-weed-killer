import React from 'react';
import {
  Text,
  View,
  Button,
  Alert,
  TouchableOpacity,
  StyleSheet
} from 'react-native';

const App = () => {
  return (
    <>
      <View>
        <Button
          onPress={() => Alert.alert('Forward button pressed')}
          title='Fwd'
          color={'black'}
          accessibilityLabel='This button will make the robot drive forward!'
        />
      </View>

      <View>
        <Button
          onPress={() => Alert.alert('Backward button pressed')}
          title='Bwd'
          color={'blue'}
          // disabled={false}
          accessibilityLabel='This button will make the robot drive BACKWARDS!!!'
        />
      </View>
      <View>
        <Button
          onPress={() => Alert.alert('Left button pressed')}
          title='Lft'
          color={'green'}
          // disabled={false}
          accessibilityLabel='This button will make the robot turn left'
        />
      </View>
      <View style={styles.backgroundColor}>
        <Button
          onPress={() => Alert.alert('Right button pressed')}
          title='Rgt'
          // disabled={false}
          accessibilityLabel='This button will make the robot turn right'
        />
      </View>
      <View style={styles.container}>
        <TouchableOpacity
          style={styles.button}
          onPress={() => Alert.alert('Different type of button')}
        >
          <Text>Fire</Text>
        </TouchableOpacity>
      </View>
    </>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: "center",
    paddingHorizontal: 10
  },
  button: {
    alignItems: "center",
    backgroundColor: "rgba(52,52,52, 0.1)",
    padding: 10
  }
});
export default App;
