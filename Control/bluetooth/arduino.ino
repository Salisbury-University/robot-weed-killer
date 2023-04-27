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
#define TRIG 52
#define ECHO 50 
#define MAX_DIST 400
SoftwareSerial bluetooth(12, 13); // declare bluetooth serial object, with established pins for Rx and Tx 
long tick = 0; // to hold # of times the main loop has been ran through
long max_ticks = 75000; // max amount of ticks to trigger emergency brake and laser disable
bool BTconnected = false; // boolean for bluetooth connection
const byte BTpin = 5; // byte to read bluetooth status from state pin
bool auto_toggle = false; // toggle variable to switch between autonomous
char in_char;
NewPing sonar(TRIG, ECHO, MAX_DIST);
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
      if (bluetooth.read() == 'y'){
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
  char in_char = bluetooth.read(); // char variable to store read byte over bluetooth
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
  bool LeftTurn = false;
  bool RightTurn = false;
  bool Straight = false;

  if(sonar.ping_cm() >= 15){ //drive forward while distance >= 10 cm
    if(bluetooth.read() == 'y'){
      auto_toggle = false;
      Serial.print("quit");
      return;
    }
    Forward();
    Serial.print("Distance = ");
    Serial.print(sonar.ping_cm());
    Serial.println(" cm");

  }
  Forward();
  if(sonar.ping_cm() < 15){ //when object is too close, first turn left
    if(bluetooth.read() == 'y'){
      auto_toggle = false;
      Serial.print("quit");
      return;
    }
    Brake();
    delay(250);
    LeftTurn = true;
    Left();
    Serial.print("Distance = ");
    Serial.print(sonar.ping_cm());
    Serial.println(" cm");
    delay(500);
  }

  Forward();
  if(LeftTurn && sonar.ping_cm() < 15){ //if left is not clear, turn right
    if(bluetooth.read() == 'y'){
      auto_toggle = false;
      Serial.print("quit");
      return;
    }
    Brake();
    delay(250);
    RightTurn = true;
    Right();
    Serial.print("Distance = ");
    Serial.print(sonar.ping_cm());
    Serial.println(" cm");
    LeftTurn = false;
    delay(750);
  }

  Forward();
  if(sonar.ping_cm() < 15){ //if right is not clear, turn around
    if(bluetooth.read() == 'y'){
      auto_toggle = false;
      Serial.print("quit");
      return;
    }
    Backward();
    delay(250);
    Brake();
    delay(250);
    Serial.print("Distance = ");
    Serial.print(sonar.ping_cm());
    Serial.println(" cm");
    RightTurn = false;
    LeftTurn = false;
    delay(500);
    RightTurn = true;
    Right();
    delay(250);    
  }
  Serial.println("Done Sonar");
  if(bluetooth.read() == 'y'){
      auto_toggle = false;
      Serial.print("quit");
      return;
    }
}