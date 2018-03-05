const int ledPin = 13; 
int incomingByte; 
int nextByte;

char PIRIn = ' ';
int LDRIn = 0;
int MotorIn = 0;
int RadiatorIn = 0;
float TemperatureIn = 0.0;

char charBuf[2];

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
        // Serial.println(incomingByte);
        // Serial.println(next);
        // Serial.println(next.length());
        // Serial.println(next[0]);
        // Serial.println(next[1]);
        if (next[1] == 'L'){
          digitalWrite(ledPin, LOW);
          //Serial.println("Low"); 
          PIRIn = 'L';
        }
        else if (next[1] == 'H'){
          digitalWrite(ledPin, HIGH);
          //Serial.println("High");
          PIRIn = 'H';
        }
      }
      else if (incomingByte == 2)
        LDRIn = (Serial.parseInt());
      else if (incomingByte == 3)
        MotorIn = 1;
      else if (incomingByte == 4)
        RadiatorIn = 1;
      else if (incomingByte == 5)
        TemperatureIn = 0.9;
      
    }
  }
  if ((PIRIn != ' ') && (LDRIn != 0) && (MotorIn != 0) && (RadiatorIn != 0) && (TemperatureIn != 0.0)){
    sendPacket();
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