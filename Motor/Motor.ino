/* the inspiration for creating the motor which controls the blinds came from
http://henrysbench.capnfatz.com/henrys-bench/arduino-output-devices/simple-dc-motor-with-an-arduino-part-1/

for the curcuit diagram. Once we created the circuit diagram the code for this file
was created from scratch using existing knowledge of how to write data to the
pins. Simply setting the motor output to max or min depending on what we
want it to achieve.
*/

//used for creating JSON objects.
#include <ArduinoJson.h>

//pin which the motor is connected to
const int motor = 3;
// pin which the LED is connected to
const int LED = 13;
// check whehter to actually perform the movement of the motor
bool blindShut = false;

//set up the board rate and output pins for the motor
void setup() {
  Serial.begin(9600);
  pinMode(motor, OUTPUT);
}


//constantly take light readings
void loop() {
  if (Serial.available() > 0) {

    //allocate memory for the JSON object
    StaticJsonBuffer<1024> jsonBuffer;
    //string to be stored as the value
    String json = Serial.readStringUntil('\n');
    //create the json object
    JsonObject& root = jsonBuffer.parseObject(json);
    Serial.println(json);
    int id = root["id"];
    int motorVal = root["motor"];
    //check that we want to interact with this arduino
    if (id == 7){]
      //do we want to interact with the motor which is on this arduino.
      if (motorVal == 1){
        digitalWrite(motor, HIGH);
        delay(1000);
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
