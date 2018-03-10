#include <ArduinoJson.h>

const int ledPin = 13; 
int incomingByte; 
int nextByte;

char PIRIn = ' ';
int LDRIn = 0;
int MotorIn = 0;
int RadiatorIn = 0;
float TemperatureIn = 0.0;

char charBuf[2];
StaticJsonBuffer<400> jsonBuffer;
void setup() {
  Serial.begin(9600);
  pinMode(ledPin, OUTPUT);
  
}

struct packet{
  char PIR;
  int LDR;
  int Motor;
  int Radiator;
  int Temperature;
};

// void loop() {
//   // see if there's incoming serial data:
//   if (Serial.available() > 0) {
//     incomingByte = Serial.read();
//     if (incomingByte == 'H') {
//       digitalWrite(ledPin, HIGH);
//       Serial.println("H");
//     }
//     else if (incomingByte == 'L') {
//       digitalWrite(ledPin, LOW);
//     }
//     else if (incomingByte  < 255){
      
//     }
//   }
// }

void loop(){
  if (Serial.available() > 0) {
    incomingByte = Serial.read();
    if (incomingByte != 0){
      Serial.println(incomingByte);
      if (incomingByte == 1){
        digitalWrite(ledPin, HIGH);
        String next = Serial.readString();
        next.toCharArray(charBuf, 2);
        if (next[1] == 'L'){
          digitalWrite(ledPin, LOW);
          Serial.println("L"); 
          PIRIn = 'L';
        }
        else if (next[1] == 'H'){
          digitalWrite(ledPin, HIGH);
          Serial.println("H");
          PIRIn = 'H';
        }
      }
      else if (incomingByte == 2){
        int brightness = Serial.read();
      }
      else if (incomingByte == 3){
        int rempera = Serial.read();
      }
    }
  }
  if ((PIRIn != ' ') && (LDRIn != 0) && (MotorIn != 0) && (RadiatorIn != 0) && (TemperatureIn != 0.0)){
    // sendPacket();
    JSON(LDRIn);
  }
  
}

void sendPacket(){
  packet thisPacket = { PIRIn, LDRIn, MotorIn, RadiatorIn, TemperatureIn};
  Serial.write((const uint8_t *)&thisPacket, sizeof(thisPacket));
  delay(5000);
  PIRIn = ' ';
  LDRIn = 0;
  MotorIn = 0;
  RadiatorIn = 0;
  TemperatureIn = 0.0;
}

void sendPIRStatus(){
  packet thisPacket = { PIRIn, LDRIn, MotorIn, RadiatorIn, TemperatureIn};
  Serial.write((const uint8_t *)&thisPacket, sizeof(thisPacket));
  delay(5000);
  PIRIn = ' ';
  LDRIn = 0;
  MotorIn = 0;
  RadiatorIn = 0;
  TemperatureIn = 0.0;
}

void JSON(int LDRIn){
  char json[] =
      "{\"LDRReading\":LDRIn,\"TemperatureReading\":TemperatureIn}";
      
      JsonObject& root = jsonBuffer.parseObject(json);

  // Test if parsing succeeds.
  if (!root.success()) {
    Serial.println("parseObject() failed");
    return;
  }

  // Fetch values.
  //
  // Most of the time, you can rely on the implicit casts.
  // In other case, you can do root["time"].as<long>();
  long temperature = root["TemperatureReading"];
  long LDRRead = root["LDRReading"];

  // Print values.
  Serial.println(temperature);
  Serial.println(LDRRead);
  Serial.println("");
}