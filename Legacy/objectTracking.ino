#include "HUSKYLENS.h"
#include "SoftwareSerial.h"
#define LMOTOR_IN1 3
#define LMOTOR_IN2 4
#define LMOTOR_IN3 7
#define LMOTOR_IN4 8

#define RMOTOR_IN1 24
#define RMOTOR_IN2 25
#define RMOTOR_IN3 32
#define RMOTOR_IN4 33

HUSKYLENS huskylens;
SoftwareSerial mySerial(10, 11);

void printResult(HUSKYLENSResult result);

void setup() {
    Serial.begin(9600);
    mySerial.begin(9600);
    pinMode (LMOTOR_IN1, OUTPUT);
    pinMode (LMOTOR_IN2, OUTPUT);
    pinMode (LMOTOR_IN3, OUTPUT);
    pinMode (LMOTOR_IN4, OUTPUT);
    pinMode (RMOTOR_IN1, OUTPUT);
    pinMode (RMOTOR_IN2, OUTPUT);
    pinMode (RMOTOR_IN3, OUTPUT); 
    pinMode (RMOTOR_IN4, OUTPUT);

    while (!huskylens.begin(mySerial))
    {
         Serial.println(F("Begin failed!"));
        Serial.println(F("1.Please recheck the \"Protocol Type\" in HUSKYLENS (General Settings>>Protocol Type>>Serial 9600)"));
        Serial.println(F("2.Please recheck the connection."));
        delay(100);
    }
}

void loop() 
{
    if (!huskylens.request()) 
Serial.println(F("Fail to request data from HUSKYLENS, recheck the connection!"));

    else if(!huskylens.isLearned()) 
Serial.println(F("Nothing learned, press learn button on HUSKYLENS to learn one!"));

    else if(!huskylens.available()) 
Serial.println(F("No block or arrow appears on the screen!"));

    else
    {
        Serial.println(F("###########"));
        while (huskylens.available())
        {
            HUSKYLENSResult result = huskylens.read();
            printResult(result);
            driveBot(result);
        }    
    }
}


void printResult(HUSKYLENSResult result){
    if (result.command == COMMAND_RETURN_BLOCK){
        Serial.println(String()+F("Block:xCenter=")+result.xCenter+F(",yCenter=")+result.yCenter+F(",width=")+result.width+F(",height=")+result.height+F(",ID=")+result.ID);
    }
    else if (result.command == COMMAND_RETURN_ARROW){
        Serial.println(String()+F("Arrow:xOrigin=")+result.xOrigin+F(",yOrigin=")+result.yOrigin+F(",xTarget=")+result.xTarget+F(",yTarget=")+result.yTarget+F(",ID=")+result.ID);
    }
    else{
        Serial.println("Object unknown!");
    }
}

void driveBot(HUSKYLENSResult result)
{
  if(result.xCenter<=140)
  {
    Left();
  }

  else if(result.xCenter>=200)
  {
    Right();
  }

    else if((result.xCenter>=140)&&(result.xCenter<=200))
  {
    if(result.width<=20)
    {
      Forward();
    }

    else if(result.width>20)
    {
      Brake();
    }
  }
  
}

void Forward(){
  digitalWrite(LMOTOR_IN1,HIGH); // High, low is fwd, low high is rev
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH);
  digitalWrite(LMOTOR_IN4,LOW);

  digitalWrite(RMOTOR_IN1,HIGH); // for right its low high fwd,
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);
  digitalWrite(RMOTOR_IN4,LOW);// this input not in correctly
  
}

void Backward(){
  digitalWrite(LMOTOR_IN1,LOW); // High, low is fwd, low high is rev
  digitalWrite(LMOTOR_IN2,HIGH);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,HIGH);

  digitalWrite(RMOTOR_IN1,LOW); // for right its low high fwd,
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);// this input not in correctly
  
}
void Left(){
  digitalWrite(LMOTOR_IN1,LOW); // High, low is fwd, low high is rev
  digitalWrite(LMOTOR_IN2,HIGH);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,HIGH);

  digitalWrite(RMOTOR_IN1,HIGH); // for right its low high fwd,
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,HIGH);
  digitalWrite(RMOTOR_IN4,LOW);
}

void Right(){
  digitalWrite(RMOTOR_IN1,LOW); // High, low is fwd, low high is rev
  digitalWrite(RMOTOR_IN2,HIGH);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,HIGH);

  digitalWrite(LMOTOR_IN1,HIGH); // for right its low high fwd,
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,HIGH);
  digitalWrite(LMOTOR_IN4,LOW);
}

void Brake(){
  digitalWrite(LMOTOR_IN1,LOW);
  digitalWrite(LMOTOR_IN2,LOW);
  digitalWrite(LMOTOR_IN3,LOW);
  digitalWrite(LMOTOR_IN4,LOW);

  digitalWrite(RMOTOR_IN1,LOW);
  digitalWrite(RMOTOR_IN2,LOW);
  digitalWrite(RMOTOR_IN3,LOW);
  digitalWrite(RMOTOR_IN4,LOW);
  
}
