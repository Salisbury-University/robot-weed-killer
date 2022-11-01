import React from "react";
import { Text, TouchableOpacity } from "react-native";
import styles from "../styles/styles";

const Button = ({title, onPress, style, textStyle }) => (
    <TouchableOpacity style={[styles.button, style]} onPress={onPress}>
        <Text style={[styles.buttonText, textStyle]}>{title.toUpperCase()}</Text>
    </TouchableOpacity>
);

export default Button;