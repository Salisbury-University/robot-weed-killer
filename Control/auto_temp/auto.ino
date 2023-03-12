#include <SoftwareSerial.h> // module for arduino to use BT

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
SoftwareSerial bluetooth(12, 13); // declare bluetooth serial object, with established pins for Rx and Tx
long tick = 0; // to hold # of times the main loop has been ran through
long max_ticks = 75000; // max amount of ticks to trigger emergency brake and laser disable
bool BTconnected = false; // boolean for bluetooth connection
const byte BTpin = 5; // byte to read bluetooth status from state pin

// ---------------------------------------------------------------- //

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
        pinMode(TRIG, OUTPUT);
        pinMode(ECHO, INPUT);
        Serial.begin(9600); // initialize serial channel
        bluetooth.begin(9600); // initialize bluetooth channel
        Brake(); // inital brake call for safety
    while(!BTconnected){ // wait for HC-05 bluetooth connection
        if(digitalRead(BTpin)==HIGH){
            BTconnected = true;
        }
    }
}

// ---------------------------------------------------------------- //

void loop(digitalRead(BTpin == HIGH)){
    while(1){
        while(/*sonar distance < optimal distance*/){
            Forward();
        }
        if(/*sonar distance >= optimal distance*/){
            Left();
            delay(750);
        }
        else if(/*sonar distance */){
            Right();
            delay()
        }
        
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