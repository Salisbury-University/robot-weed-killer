#include <SoftwareSerial.h> // module for arduino to use BT
#include "NewPing.h"
// ---define pins--- //
#define relay_Pin 46
#define LMOTOR_IN1 3
#define LMOTOR_IN2 4
#define LMOTOR_IN3 7
#define LMOTOR_IN4 8
#define RMOTOR_IN1 24
#define RMOTOR_IN2 25
#define RMOTOR_IN3 32
#define RMOTOR_IN4 33

//Sonar sensor pins, accomodates all three current sensors
#define TRIGLEFT 52
#define ECHOLEFT 50
#define TRIGRIGHT 42
#define ECHORIGHT 40
#define TRIGREAR 10
#define ECHOREAR 9
#define MAX_DIST 400
SoftwareSerial bluetooth(12, 13); // declare bluetooth serial object, with established pins for Rx and Tx 
long tick = 0; // to hold # of times the main loop has been ran through
long max_ticks = 75000; // max amount of ticks to trigger emergency brake and laser disable
bool BTconnected = false; // boolean for bluetooth connection
const byte BTpin = 5; // byte to read bluetooth status from state pin
bool auto_toggle = false; // toggle variable to switch between autonomous
char in_char;
NewPing sonar(TRIG, ECHO, MAX_DIST);
//1st sonar sensor (left) is DIGITAL PIN: echo: 50, and trigger: 52
//2nd sonar sensor (right) is DIGITAL PIN: echo: 40, trigger: 42
//3rd sonar sensor (rear) is DIGITAL PIN: echo: 9, and trigger: 10
//New sonar sensor ping initialization
NewPing sonarleft(TRIGLEFT, ECHOLEFT, MAX_DIST);
NewPing sonarright(TRIGRIGHT, ECHORIGHT, MAX_DIST);
NewPing sonarrear(TRIGREAR, ECHOREAR, MAX_DIST);
int distleft, distright, distrear;
void setup(){
	// configure motors with pins
	pinMode(relay_Pin, OUTPUT);
	pinMode (LMOTOR_IN1, OUTPUT);
	pinMode (LMOTOR_IN2, OUTPUT);
	pinMode (LMOTOR_IN3, OUTPUT);
	pinMode (LMOTOR_IN4, OUTPUT);
	pinMode (RMOTOR_IN1, OUTPUT);
	pinMode (RMOTOR_IN2, OUTPUT);
	pinMode (RMOTOR_IN3, OUTPUT); 
	pinMode (RMOTOR_IN4, OUTPUT);
	pinMode(BTpin,INPUT); 
	Serial.begin(9600); // initialize serial channel
	bluetooth.begin(9600); // initialize bluetooth channel
	Brake(); // inital brake call for safety
    while(!BTconnected){ // wait for HC-05 bluetooth connection
        if(digitalRead(BTpin)==HIGH){
            BTconnected = true;
            in_char == 's';
        }
    }
}

// --------------------main control loop-------------------- //
void loop(){
  while(digitalRead(BTpin)==HIGH){ // only run drive code when connection is active
  in_char == bluetooth.read();
    if(auto_toggle == false || in_char == 'y'){
      Serial.println("manual");
      manual();
    }
    else{
      Serial.println("auto");
      if (in_char == 'y'){
        auto_toggle = false;
        return;
      }
      autonomous();
    }
  }
}

// --------------------robot movement functions-------------------- //
void Forward(){
  digitalWrite(LMOTOR_IN1,LOW); // HIGH,LOW sets the motor fowards
  digitalWrite(LMOTOR_IN2,HIGH); // LIN1 and LIN2 is motor 1(left side)
  digitalWrite(LMOTOR_IN3,LOW);// LIN3 and LIN4 is motor 2(left Side)
  digitalWrite(LMOTOR_IN4,HIGH);
  
  digitalWrite(RMOTOR_IN1,HIGH); // Both left and right side go foward
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);// RIN1 and RIN2 is motor 3(right side)
  digitalWrite(RMOTOR_IN4,LOW); // RIN3 and RIN4 is motor 4(right side) 
}

void Backward(){ // robot moves backwards
  digitalWrite(LMOTOR_IN1,HIGH); // LOW,HIGH sets the motor backwards
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH);
  digitalWrite(LMOTOR_IN4,LOW);

  digitalWrite(RMOTOR_IN1,LOW); // Both left and right side go backwards
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);
}

void Left(){ // robot rotates counter-clockwise (left)
  digitalWrite(LMOTOR_IN1,HIGH); // left side motors go backwards
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH); 
  digitalWrite(LMOTOR_IN4,LOW);

  digitalWrite(RMOTOR_IN1,HIGH); // right side motors go forwards
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);
  digitalWrite(RMOTOR_IN4,LOW);
}

void Right(){ // robot rotates clockwise (right)
  digitalWrite(LMOTOR_IN1,LOW); // left side motors go forwards,
  digitalWrite(LMOTOR_IN2,HIGH);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,HIGH);

  digitalWrite(RMOTOR_IN1,LOW); // right side motors go backwards
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);
}

void Brake(){ // disables all motor movement
  digitalWrite(LMOTOR_IN1,LOW);
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,LOW);

  digitalWrite(RMOTOR_IN1,LOW);
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,LOW); 
}

/* // NOT USED: with current hardware this turn implementation is sloppy
void ForwardLeft(){ // robot turns left while moving slightly forward at the same time
  digitalWrite(RMOTOR_IN1,HIGH); // right motors go forward
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);
  digitalWrite(RMOTOR_IN4,LOW);
}

// NOT USED: with current hardware this turn implementation is sloppy
void ForwardRight(){ //  robot turns right while moving slightly forward at the same time
  digitalWrite(LMOTOR_IN1,HIGH); // left motors go forward
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH);
  digitalWrite(LMOTOR_IN4,LOW);
}
*/

// -------------------- laser activation functions --------------------//
void LaserOn(){ // toggles relay pin to enable laser
	digitalWrite(relay_Pin,HIGH);
}

void LaserOff(){ // toggles relay pin to disable laser
	digitalWrite(relay_Pin,LOW);
}

void LaserBurst(){ // enables laser for specified amount of seconds in sleep function, then disables
	digitalWrite(relay_Pin,HIGH);
	delay(3000);
	digitalWrite(relay_Pin,LOW);
}

void RobotBoogie(){ // makes the robot bust a move, used for debugging motor control
  Left();
  delay(250);
  Right();
  delay(250);
  Left();
  delay(250);
  Right();
  delay(250);
  Left();
  delay(250);
  Right();
  delay(250);
  Forward();
  delay(250);
  Backward();
  delay(250);
  Forward();
  delay(250);
  Backward();
  delay(250);
  Forward();
  delay(250);
  Backward();
  delay(250);
	Brake();
}

void manual(){
  in_char = bluetooth.read(); // char variable to store read byte over bluetooth
  auto_toggle = false;   
  if (in_char=='q' || in_char=='l' || in_char=='c'){ // inputs for left turns
    Left();
  }
  else if(in_char=='e' || in_char=='z' || in_char=='r'){ // inputs for right turns
    Right();
  }
  else if(in_char=='b'){ // backwards
    Backward();
  }
  else if(in_char=='f'){ // forwards
    Forward();
  }
  else if(in_char=='s'){ // stops
    Brake();
  }
  else if(in_char=='p'){
    RobotBoogie();
  }
  else if(in_char=='+'){ // laser toggle on
    LaserOn();
  }
  else if(in_char=='-'){ // laser toggle off
    LaserOff();
  }
  else if(in_char == 't'){ // toggle to autonomous
    auto_toggle = true;
  }
}

void autonomous(){
  in_char = bluetooth.read(); // char variable to store read byte over bluetooth
  if (in_char == 'y'){
    auto_toggle = false;
    return;
  }
  //Flags for turn statuses
  bool LeftTurn = false;
  bool RightTurn = false;
  bool Straight = false;
  bool Reversing = false;

  distleft = sonarleft.ping_cm();
  distright = sonarright.ping_cm();
  distrear = sonarrear.ping_cm();

  if(distleft >= 15 && distright >= 15){ //if left and right are clear, drive forward
    //Serial.println("MAIN DRIVE FORWARD CONDITION");
    Straight = true;
    Forward();
    //Serial.println("CALL FORWARD 99");
    Serial.print("Left distance: ");
    Serial.print(distleft);
    Serial.println(" cm");
    Serial.print("Right distance: ");
    Serial.print(distright);
    Serial.println(" cm");
    Serial.print("Rear distance: ");
    Serial.print(distrear);
    Serial.println(" cm");
  }

  Forward();
  //Serial.println("CALL FORWARD 112");
  if(distleft < 15 && distright >= 15){ //if left sensor detects obstacle within 15 cm, turn right
    //Serial.println("LEFT SENSOR IS BLOCKED CONDITION");
    Brake();
    //Serial.println("CALL BRAKE 116");
    Straight = false;
    delay(250);
    //Serial.println("CALL DELAY 119");
    RightTurn = true;
    Right();
    //Serial.println("CALL RIGHT 122");
    Serial.print("Left distance: ");
    Serial.print(distleft);
    Serial.println(" cm");
    Serial.print("Right distance: ");
    Serial.print(distright);
    Serial.println(" cm");
    Serial.print("Rear distance: ");
    Serial.print(distrear);
    Serial.println(" cm");
    delay(500);
    //Serial.println("CALL DELAY 133");
  }
  RightTurn = false;

  Straight = true;
  Forward();
  //Serial.println("CALL FORWARD 139");
  if(distright < 15 && distleft >= 15){ //if right sensor detects obstacle within 15 cm, turn left
    //Serial.println("RIGHT SENSOR IS BLOCKED CONDITION");
    Brake();
    //Serial.println("CALL BRAKE 143");
    Straight = false;
    delay(250);
    //Serial.println("CALL DELAY 146");
    Left();
    //Serial.println("CALL LEFT 148");
    Serial.print("Left distance: ");
    Serial.print(distleft);
    Serial.println(" cm");
    Serial.print("Right distance: ");
    Serial.print(distright);
    Serial.println(" cm");
    Serial.print("Rear distance: ");
    Serial.print(distrear);
    Serial.println(" cm");
    delay(500);
    //Serial.println("CALL DELAY 159");
  }
  LeftTurn = false;

  Straight = true;
  Forward();
  //Serial.println("CALL FORWARD 165");
  if(distright < 15 && distleft < 15){ //if both front sensors are obstructed, drive in reverse
    //Serial.println("BOTH FRONT SENSORS ARE BLOCKED CONDITION");
    Brake();
    //Serial.println("CALL BRAKE 169");
    Straight = false;
    delay(250);
    //Serial.println("CALL DELAY 172");
    Reversing = true;
    Backward();
    //Serial.println("CALL BACKWARD 175");
    Serial.print("Left distance: ");
    Serial.print(distleft);
    Serial.println(" cm");
    Serial.print("Right distance: ");
    Serial.print(distright);
    Serial.println(" cm");
    Serial.print("Rear distance: ");
    Serial.print(distrear);
    Serial.println(" cm");
    if(distrear > 15){ //if rear sensor is blocked, turn right
      //Serial.println("REAR SENSOR IS BLOCKED CONDITION");
      Brake();
      //Serial.println("CALL BRAKE 188");
      Reversing = false;
      RightTurn = true;
      Right();
      //Serial.println("CALL RIGHT 192");
      Serial.print("Left distance: ");
      Serial.print(distleft);
      Serial.println(" cm");
      Serial.print("Right distance: ");
      Serial.print(distright);
      Serial.println(" cm");
      Serial.print("Rear distance: ");
      Serial.print(distrear);
      Serial.println(" cm");
      delay(250);
      //Serial.println("CALL DELAY 203");
      RightTurn = false;
    }
    else{ //if rear sensor is clear, turn right after half second of reversing
      Serial.println("REAR SENSOR IS CLEAR CONDITION");
      delay(500);
      //Serial.println("CALL DELAY 209");
      Reversing = false;
      RightTurn = true;
      Right();
      //Serial.println("CALL RIGHT 213");
      Serial.print("Left distance: ");
      Serial.print(distleft);
      Serial.println(" cm");
      Serial.print("Right distance: ");
      Serial.print(distright);
      Serial.println(" cm");
      Serial.print("Rear distance: ");
      Serial.print(distrear);
      Serial.println(" cm");
      delay(250);
      //Serial.println("CALL DELAY 224");
      RightTurn = false;
    }
  }

  Straight = true;
  Forward();
  //Serial.println("CALL FORWARD 231");

}
