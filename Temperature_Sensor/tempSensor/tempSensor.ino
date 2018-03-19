#include <ArduinoJson.h>

int ThermistorPin = 0;
int tempValue;
float logR2, R2, T, Tc, Tf; //used to calculate Celcius and Fahrenheit
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07; //Used to calculate celcius
const int buzzer = 9; //Define buzzer pin 
const int LED = 13; 

struct values{
  int ID;
  int Val;
}; //Struct used to send values to receieving Arduino connected to Pi

void setup() {
Serial.begin(9600);
pinMode(buzzer, OUTPUT);
pinMode(LED, OUTPUT);

}

void loop() {

  StaticJsonBuffer<1024> jsonBuffer;
  JsonObject& obj = jsonBuffer.createObject();
  
  if(Serial.available() > 0){
    String JSON = Serial.readStringUntil('\n');
    JsonObject& objRec = jsonBuffer.parseObject(JSON);
    int value = objRec["id"];
    Serial.println(JSON);
    Serial.println();
    Serial.println(value);
    if(value == 7){

      int value2 = objRec["radiator"];
      Serial.println(value2);
      if(value2 == 1){
          digitalWrite(LED, HIGH); //LED light on to signal radiator on  
        }else if(value2 == 0){
          digitalWrite(LED, LOW); //LED light off to signal radiator off
          }    
      }    
    }

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

