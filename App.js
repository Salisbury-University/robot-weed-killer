import React, { Component } from 'react';  // Component imported for App class definition
import Toggle from 'react-native-toggle-input'  // imported for the toggle switch (possibly temporary)
import { Pressable, StyleSheet, Image, Text, View, Alert, TouchableRipple, TouchableHighlight } from 'react-native';
import BluetoothSerial from 'react-native-bluetooth-serial-next';   // impoorts the BLuetoothSerial object from the API

/**
 * Below is the async() function for API calls to the Bluetooth Serial API 
 * will most likely be implemented by the next meeting; App.js most likely needs to be changed to a class definition to include async
 * function and multiple other function definitions and objects from the BluetoothSerial API.
 * 
 */
async() => {
  // saves the list of all the connected Bluetooth devices to the devices variable
  const devices = await BluetoothSerial.list();   // async() required for commands like await and event, etc.
}

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

const styles = StyleSheet.create({
  buttonContainer: {
    flex: 1,
    justifyContent: "center",
    backgroundColor: "#e6f7ff",
  },
  leftButton: {
    backgroundColor: "#0066cc",
    position: 'absolute',
    bottom: 110,
    left: 30,
    height: 30,
    width: 65,
    borderRadius: 20, 
  },
  forwardButton: {
    backgroundColor: "#0066cc",
    position: 'absolute',
    bottom: 150,
    left: 103,
    height: 60,
    width: 30,
    borderRadius: 20,
  },
  rightButton: {
    backgroundColor: "#0066cc",
    position: 'absolute',
    bottom: 110,
    left: 140,
    height: 30,
    width: 65,
    borderRadius: 20,
  },
  backButton: {
    backgroundColor: "#0066cc",
    position: 'absolute',
    bottom: 40,
    left: 103,
    height: 60,
    width: 30,
    borderRadius: 20,
  },
  fButton: {
    backgroundColor: "red",
    position: 'absolute',
    bottom: 50,
    right: 100,
    height: 80,
    width: 80,
    borderRadius: 40,
  },
  autoButton: {
    size:'small',
    position: 'absolute',
    top: 15,
    left: 327,
    height: 20,
    width: 40,
    borderRadius: 10,
  },
  autoText:{
   alignSelf:"center",
   color: 'white',
  },
  Reticule: {
    justifyContent: 'center',
    alignItems:'center',
  },
  text: {
    fontSize: 16
  },
  wrapperCustom: {
    borderRadius: 8,
    padding: 6
  }
});

export default App;
