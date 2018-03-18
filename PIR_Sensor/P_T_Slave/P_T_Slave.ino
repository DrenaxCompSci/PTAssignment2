#include <ArduinoJson.h>

const int pirled = 13; 
const int templed = 12; 
const int ldrled = 11; 
int incomingByte; 
int nextByte;

long PIRIn = NULL;
long LDRIn = 0;
int MotorIn = 0;
int RadiatorIn = 0;
long TemperatureIn = 0.0;

StaticJsonBuffer<512> jsonBuffer;
StaticJsonBuffer<512> jsonBuffer2;
JsonObject& obj = jsonBuffer.createObject();
JsonObject& obj2 = jsonBuffer2.createObject();

// char charBuf[2];
void setup() {
  Serial.begin(9600);
  pinMode(pirled, OUTPUT);
  pinMode(templed, OUTPUT);
  pinMode(ldrled, OUTPUT);
}

struct packet{
  char PIR;
  int LDR;
  int Motor;
  int Radiator;
  int Temperature;
};

void loop(){
  if (Serial.available() > 0) {
    String json = Serial.readStringUntil('\n');
    JsonObject& root = jsonBuffer.parseObject(json);
    long sensor = root["id"];
    if (sensor == 1){ // pir
      PIRIn = root["value"];
    }
    else if (sensor == 2){ //ldr
      LDRIn = root["value"];
      digitalWrite(ldrled, HIGH);
    }
    else if (sensor == 3){ //thermistor
      TemperatureIn = root["value"];
      digitalWrite(templed, HIGH);
    }
    else if (sensor == 5){ //pi
      digitalWrite(pirled, HIGH);
      long piRadiatorCommand = root["temperature"];
      int piMotorCommand = root["motor"];
      obj2["id"] = 7; 
      obj2["radiator"] = 1;// piRadiatorCommand;
      obj2["motor"] = piMotorCommand;
      obj2.printTo(Serial);
    }
    if ((LDRIn != 0) && (TemperatureIn != 0.0)){
      JSON();
    }
  }
}

// void sendPacket(){
//   packet thisPacket = { PIRIn, LDRIn, MotorIn, RadiatorIn, TemperatureIn};
//   Serial.write((const uint8_t *)&thisPacket, sizeof(thisPacket));
//   delay(5000);
//   PIRIn = ' ';
//   LDRIn = 0;
//   MotorIn = 0;
//   RadiatorIn = 0;
//   TemperatureIn = 0.0;
// }

// void sendPIRStatus(){
//   packet thisPacket = { PIRIn, LDRIn, MotorIn, RadiatorIn, TemperatureIn};
//   Serial.write((const uint8_t *)&thisPacket, sizeof(thisPacket));
//   delay(5000);
//   PIRIn = ' ';
//   LDRIn = 0;
//   MotorIn = 0;
//   RadiatorIn = 0;
//   TemperatureIn = 0.0;
// }

void JSON(){
  obj["id"] = "6"; //slave
  obj["temperature"] = TemperatureIn;
  obj["ldr"] = LDRIn;
  obj["pir"] = PIRIn; //72 = high, 76 = Low (ascii values)
  
  obj.printTo(Serial);
  Serial.println();
  TemperatureIn = 0.0;
  LDRIn = 0;
  digitalWrite(templed, LOW);
  digitalWrite(pirled, LOW);
}