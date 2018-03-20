//Temperature Sensor example code that has been used and modifed: http://www.circuitbasics.com/arduino-thermistor-temperature-sensor-tutorial/

#include <ArduinoJson.h>

int ThermistorPin = 0; //Define thermistor pin
int tempValue;
float logR2, R2, T, Tc, Tf; //used to calculate Celcius and Fahrenheit
float c1 = 1.009249522e-03, c2 = 2.378405444e-04, c3 = 2.019202697e-07; //Used to calculate celcius
const int buzzer = 9; //Define buzzer pin 
const int LED = 13; //Define radiator LED

struct values{
  int ID;
  int Val;
}; //Struct used to send temp value with unique ID to receieving Arduino connected to Pi via XBee radio communication

void setup() {
Serial.begin(9600);
pinMode(buzzer, OUTPUT);
pinMode(LED, OUTPUT);

}

void loop() {
  StaticJsonBuffer<1024> jsonBuffer; //Buffer to contain JSON objects
  JsonObject& obj = jsonBuffer.createObject(); //Create JSON object to send to Raspberry Pi control HUB
  
  if(Serial.available() > 0){
    String JSON = Serial.readStringUntil('\n'); //Split incoming JSON objects at each new line
    JsonObject& objRec = jsonBuffer.parseObject(JSON); //Assign incoming object to variable
    int id = objRec["id"]; //Obtain the value at "id" key and assign to variable
    Serial.println(JSON);
    Serial.println();
    
    if(id == 7){
      int radiator = objRec["radiator"]; //Obtain the value at "radiator" key and assign to variable
      Serial.println(radiator);
      if(radiator == 1){
          digitalWrite(LED, HIGH); //LED light on to signal radiator on  
        }else if(radiator == 0){
          digitalWrite(LED, LOW); //LED light off to signal radiator off
          }    
      }    
    }

  tempValue = analogRead(ThermistorPin); //Obtain raw temperature data from thermistor pin
  R2 = 10000 * (1023.0 / (float)tempValue - 1.0); //Calculate the resistance of the thermistor
  logR2 = log(R2); //Apply log operation to resistance
  T = (1.0 / (c1 + c2*logR2 + c3*logR2*logR2*logR2)); //Temperature in Fahrenheit
  Tc = T - 273.15; //Temperature in Celcius


  //If temperature exceeds 25 degrees celcius, sound the buzzer and switch the warning LED light on 
  if (Tc > 25) {
       digitalWrite(buzzer, HIGH); //LED lights up if 
       tone(buzzer, 1000, 10000);
   }
   
   obj["id"] = 3; //Assign JSON object being sent with unique ID that is associated with the temperature sensor
   obj["value"] = Tc; //Assign the current temperature value in celcius to the value of the JSON object
   obj.printTo(Serial); //Print the JSON object (string) to the serial so that it is sent to the receiving XBee and Raspberry Pi
   Serial.println(); 
   delay(10000); //Create JSON object and print to serial every 10 seconds
   
}

