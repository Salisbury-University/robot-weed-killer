import { StyleSheet } from "react-native";

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


export default styles;