#include <ArduinoJson.h>

const int motor = 3; 
StaticJsonBuffer<512> jsonBuffer;

void setup() {
  Serial.begin(9600);
  pinMode(motor, OUTPUT);
}

void loop() {
  if (Serial.available() > 0) {
    String json = Serial.readStringUntil('\n');
    JsonObject& root = jsonBuffer.parseObject(json);
    int id = root["id"];
    int motorVal = root["motor"];
    if (id == 7){
      if (motorVal == 1){
        digitalWrite(motor, HIGH);
        delay(5000);
        digitalWrite(motor, LOW);
      }
    }
  }
}