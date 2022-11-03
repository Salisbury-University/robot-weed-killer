/**********************************************
 * 
 *  @Author: Zachary Moore
 *  @Date: 11/01/2022
 *  @Description: This page styles and displays any listed devices that are found by the bluetooth scanner, 
 *                  which also shows the pair status of the device by changing its state and background color.
 * 
 *********************************************/

import React, { Component } from "react";
import {
    ScrollView,
    Text,
    TouchableHighlight,
    View,
    ToastAndroid,
    StyleSheet
} from "react-native";
// import styles from "../styles/styles";
import BluetoothSerial from "react-native-bluetooth-serial-next";
import { Button, List, ListItem } from '@rneui/base';

const ListModel = props => (
    <View>
        <Text
          style={{
            fontWeight: "bold",
            fontSize: 20,
            fontFamily: 'sans-serif',
            paddingTop: 20,
            paddingLeft: 15
          }}
        >
            {props.title}
        </Text>
        <List>
            {props.devices.map(item => (
                <ListItem
                  containerStyle={{
                    backgroundColor: props.deviceId == item.id ? "green" : "white"
                  }}
                  key={item.id}
                  onPressRightIcon={e => props.connect(item)}
                  rightIcon={{ name: "bluetooth" }}
                  title={item.name}
                  subtitle={`ID: ${item.id}`}
                />
            ))}
        </List>
    </View>
);

class DeviceList extends Component {
    bluetooth = BluetoothSerial
    constructor(props) {
        super(props);
        this.state = {
            paired: [],
            unpaired: [],
            deviceId: 0,
            deviceName: ""
        };
    }

    async componentDidMount() {
        this.scanDevice();
    }

    scanDevice = async e => {
        const unpaired = await this.bluetooth.discoverUnpairedDevices();
        const paired = await this.bluetooth.list();
        this.setState({ paired, unpaired });
    };

    connect = device => {
        this.bluetooth
         .connect(device.id)
         .then(res => {
            this.setState({ deviceId: device.id, deviceName: device.name });
         })
         .catch(error => {
            ToastAndroid.showWithGravity(
                `Connection Error: Device not available`,
                6000,
                ToastAndroid.BOTTOM,
                0,
                25
            );
         });
    };

    disconnect = () => {
        this.bluetooth
         .disconnect()
         .then(res => {
            this.setState({ deviceId: 0, deviceName: "" });
         })
         .catch(error => {
            ToastAndroid.showWithGravity(
                `Error: Cannot disconnect`,
                6000,
                ToastAndroid.BOTTOM,
                0,
                25
            );
         });
    };

    render() {
        return (
            <View style={styles.container}>
                <View
                  style={{
                    flex: 2,
                    flexDirection: "row",
                    justifyContent: "space-between",
                    backgroundColor: "white",
                    marginBottom: 10
                  }}
                >
                    <Button
                      color={"white"}
                      backgroundColor={"#0F728F"}
                      small
                      onPress={this.scanDevice}
                      title={"Scan"}
                    />
                    <Button
                      disabled={this.state.deviceId === 0}
                      color={"white"}
                      backgroundColor={"#0F728F"}
                      small
                      onPress={this.disconnect}
                      title={"Disconnect"}
                    />
                </View>
                <ScrollView
                  contentContainerStyle={{
                  }}
                >
                    <ListModel
                      title={"Paired devices"}
                      devices={this.state.paired}
                      connect={this.connect}
                      deviceId={this.state.deviceId}
                    />
                    <ListModel
                      title={"Available devices"}
                      devices={this.state.unpaired}
                      connect={this.connect}
                      deviceId={this.state.deviceId}
                    />
                </ScrollView>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 2,
        paddingTop: 15
    }
});

/*
class DeviceList extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            refreshing: false
        };
    }

    onDevicePressed = device => () => {
        if(typeof this.props.onDevicePressed === "function") {
            this.props.onDevicePressed(device);
        }
    };

    onRefresh = async () => {
        if(typeof this.props.onRefresh === "function") {
            this.setState({ refreshing: true });
            await this.props.onRefresh();
            this.setState({ refreshing: false });
        }
    };

    render() {
        const { devices = [] } = this.props;
        const { refreshing } = this.state;

        return (
            <ScrollView
                style={styles.container}
                refreshControl={
                    <RefreshControl refreshing={refreshing} onRefresh={this.onRefresh} />
                }
            >
                <View style={styles.listContainer}>
                    {devices.map(device => (
                        <TouchableHighlight
                          underlayColor="#eee"
                          key={device.id}
                          style={styles.listItem}
                          onPress={this.onDevicePressed(device)}
                        >
                            <View style={{ flexDirection: "column" }}>
                                <View style={{ flexDirection: "row" }}>
                                    <Text
                                      style={[
                                        styles.listItemStatus,
                                        {
                                            backgroundColor: device.paired ? "green" : "gray"
                                        }
                                      ]}
                                    >
                                        {device.paired ? "PAIRED" : "UNPAIRED"}
                                    </Text>
                                    <Text
                                      style={[
                                        styles.listItemStatus,
                                        {
                                            backgroundColor: device.connected ? "green" : "gray",
                                            marginLeft: 5
                                        }
                                      ]}
                                    >
                                        {device.connected ? "CONNECTED" : "DISCONNECTED"}
                                    </Text>
                                </View>
                                <View style={{ flexDirection: "column" }}>
                                    <Text style={{ fontWeight: "bold", fontSize: 18 }}>
                                        {device.name}
                                    </Text>
                                    <Text>{`<${device.id}>`}</Text>
                                </View>
                            </View>
                        </TouchableHighlight>
                    ))}
                </View>
            </ScrollView>
        );
    }
} */

export default DeviceList;