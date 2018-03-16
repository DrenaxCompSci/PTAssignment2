#include <ArduinoJson.h>

int ThermistorPin = 0;
int tempValue;
float logR2, R2, T, Tc, Tf; //used to calculate Celcius and Fahrenheit
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07; //Used to calculate celcius
const int buzzer = 9; //Define buzzer pin 

StaticJsonBuffer<512> jsonBuffer;
JsonObject& obj = jsonBuffer.createObject();

struct values{
  int ID;
  int Val;
}; //Struct used to send values to receieving Arduino connected to Pi

void setup() {
Serial.begin(9600);
pinMode(buzzer, OUTPUT);
}

void loop() {

  tempValue = analogRead(ThermistorPin);
  R2 = 10000 * (1023.0 / (float)tempValue - 1.0);
  logR2 = log(R2);
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2));
  Tc = T - 273.15;


  if (Tc > 25) {
       digitalWrite(buzzer, HIGH); //LED lights up if 
       tone(buzzer, 1000, 10000);
   }
   
   //values variable2 = {3,Tc};
   //Serial.write((const uint8_t *)&variable2, sizeof(variable2)); //Send data to receiving Arduino & XBee
   obj["id"] = 3;
   obj["value"] = Tc;
   obj.printTo(Serial);
   Serial.println(); 
   //Serial.println(Tc); Print out temp to serial monitor for testing 
   delay(10000);
   
}

