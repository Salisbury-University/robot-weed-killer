import React, { Component } from 'react';  // Component imported for App class definition
import Toggle from 'react-native-toggle-input'  // imported for the toggle switch (possibly temporary)
import { 
  Pressable, 
  StyleSheet, 
  Image, 
  Text, 
  View, 
  Alert, 
  TouchableRipple, 
  TouchableHighlight,
  Modal,
  ActivityIndicator,
  Platform,
  SafeAreaView,
  Switch,
  ScrollView,
  TouchableOpacityBase,
} from 'react-native';
import DeviceList from './components/DeviceList';
import styles from './styles/styles';
import Button from './components/Button';

/**
 * Below is the async() function for API calls to the Bluetooth Serial API 
 * will most likely be implemented by the next meeting; App.js most likely needs to be changed to a class definition to include async
 * function and multiple other function definitions and objects from the BluetoothSerial API.
 * 
 */

// will most likely be converted to class App extends React.Component {} 
const App = () => {
  const [toggle, setToggle] = React.useState(false);

  return (
  <><View style={styles.buttonContainer}>

    <View style= {styles.autoButton}>
    <Toggle toggle={toggle} setToggle={setToggle} color={'blue'} onTrue={() => Alert.alert('Now in Auto Mode')}/>
    </View>

    <View style={styles.Reticule}>
        <Image source={require('./Images/laser2.png')}/>
    </View>
        <Pressable
            onPress={() => Alert.alert('Now in Auto Mode')}
            accessibilityLabel='automatic mode'>
        </Pressable>
    
        <Pressable
            style={styles.leftButton}
            onPress={() => Alert.alert('Left button pressed')}
            android_ripple={{color: 'blue', borderless: true}}
            accessibilityLabel='This button will make the robot rotate left'>
        </Pressable>

        <Pressable
            style={styles.forwardButton}
            onPress={() => Alert.alert('Forward Button Pressed')}
            android_ripple={{color: 'blue', borderless: true}}
            accessibilityLabel='This button will make the robot move forward'>
        </Pressable>

        <Pressable
            style={styles.rightButton}
            onPress={() => Alert.alert('Right Button Pressed')}
            android_ripple={{color: 'blue', borderless: true}}
            accessibilityLabel='This button will make the robot rotate right'>
        </Pressable>

        <Pressable
            style={styles.backButton}
            onPress={() => Alert.alert('Back Button Pressed')}
            android_ripple={{color: 'blue', borderless: true}}
            accessibilityLabel='This button will make the robot move backward'>
        </Pressable>

        <Pressable
            style={styles.fButton}
            onPress={() => Alert.alert('FIRE')}
            accessibilityLabel='This button will fire the laser'>
        </Pressable>
    </View></>
  );
};

export default App;
