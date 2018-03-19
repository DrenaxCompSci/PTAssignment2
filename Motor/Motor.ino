#include <ArduinoJson.h>

const int motor = 3; 
const int LED = 13;
bool blindShut = false;

void setup() {
  Serial.begin(9600);
  pinMode(motor, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    StaticJsonBuffer<1024> jsonBuffer;
    String json = Serial.readStringUntil('\n');
    JsonObject& root = jsonBuffer.parseObject(json);
    Serial.println(json);
    int id = root["id"];
    int motorVal = root["motor"];
    if (id == 7){
      if (motorVal == 1){
        digitalWrite(motor, HIGH);
        delay(5000);
        digitalWrite(motor, LOW);
        if(blindShut == false){
        digitalWrite(LED, HIGH);
        blindShut = true;
        }else{
          digitalWrite(LED, LOW);
          blindShut = false;
          }
      }
    }
  }
}
