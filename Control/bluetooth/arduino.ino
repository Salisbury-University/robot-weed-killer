#include <SoftwareSerial.h> // module for arduino to use BT
SoftwareSerial bluetooth(12, 13); // declare bluetooth serial object, with established pins for Rx and Tx 
// define pins
#define BTpin 11
#define relay_Pin 46
#define LMOTOR_IN1 3
#define LMOTOR_IN2 4
#define LMOTOR_IN3 7
#define LMOTOR_IN4 8
#define RMOTOR_IN1 24
#define RMOTOR_IN2 25
#define RMOTOR_IN3 32
#define RMOTOR_IN4 33
long tick = 0; // to hold # of times the main loop has been ran through
long max_ticks = 75000; // max amount of ticks to trigger emergency brake and laser disable
bool is_connected = false;
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
}

// --------------------main control loop-------------------- //
void loop() {
    while(1){
      char in_char = bluetooth.read(); // char variable to store read byte over bluetooth   
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
      else if(in_char=='l'){
        RobotBoogie();
      }
      else if(in_char=='+'){ // laser toggle on
        LaserOn();
      }
      else if(in_char=='-'){ // laser toggle off
        LaserOff();
      }
      /*tick++; // cycle completed, add tick to the counter
      if(tick >= max_ticks){ // check # of ticks
        tick = 0;
        Brake();
        LaserOff();
      */}
    }
}

// --------------------robot movement functions-------------------- //
void Forward(){
  digitalWrite(LMOTOR_IN1,HIGH); // HIGH,LOW sets the motor fowards
  digitalWrite(LMOTOR_IN2,LOW); // LIN1 and LIN2 is motor 1(left side)
  digitalWrite(LMOTOR_IN3,HIGH);// LIN3 and LIN4 is motor 2(left Side)
  digitalWrite(LMOTOR_IN4,LOW);
  
  digitalWrite(RMOTOR_IN1,HIGH); // Both left and right side go foward
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);// RIN1 and RIN2 is motor 3(right side)
  digitalWrite(RMOTOR_IN4,LOW); // RIN3 and RIN4 is motor 4(right side) 
}

void Backward(){ // robot moves backwards
  digitalWrite(LMOTOR_IN1,LOW); // LOW,HIGH sets the motor backwards
  digitalWrite(LMOTOR_IN2,HIGH);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,HIGH);

  digitalWrite(RMOTOR_IN1,LOW); // Both left and right side go backwards
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);
}
void Left(){ // robot rotates counter-clockwise (left)
  digitalWrite(LMOTOR_IN1,LOW); // left side motors go backwards
  digitalWrite(LMOTOR_IN2,HIGH);
  digitalWrite(LMOTOR_IN3,LOW); 
  digitalWrite(LMOTOR_IN4,HIGH);

  digitalWrite(RMOTOR_IN1,HIGH); // right side motors go forwards
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);
  digitalWrite(RMOTOR_IN4,LOW);
}

void Right(){ // robot rotates clockwise (right)
  digitalWrite(RMOTOR_IN1,LOW); // right side motors go backwards
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);

  digitalWrite(LMOTOR_IN1,HIGH); // left side motors go forwards,
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH);
  digitalWrite(LMOTOR_IN4,LOW);
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
    delay(1000);
    Right;
    delay(1000);
    Left();
    delay(1000);
    Right;
    delay(1000);
    Left();
    delay(1000);
    Right;
    delay(1000);
    Forward();
    delay(1000);
    Backward();
    delay(1000);
    Forward();
    delay(1000);
    Backward();
    delay(1000);
    Forward();
    delay(1000);
    Backward();
    delay(1000);
}
