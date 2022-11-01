import React from "react";
import {
    ScrollView,
    Text,
    TouchableHighlight,
    View,
    RefreshControl
} from "react-native";
import styles from "../styles/styles";

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
}

export default DeviceList;