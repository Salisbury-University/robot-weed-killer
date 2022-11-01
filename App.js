/**************************************************
 *  @Authors: Zach Moore and Emily Hitchcock
 *  @Date: 10/01/2022
 *  @Description: This is the main page of the app to control the robot. This will contain the buttons and the fire button in
 *                  order to control it's movement and laser firing. For the future, a toggle button is included to switch
 *                  between user control and autonomous driving.
 * 
 **************************************************/

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
import DeviceList from './src/components/DeviceList';
import Button from './src/components/Button';
import styles from './src/styles/styles';

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
