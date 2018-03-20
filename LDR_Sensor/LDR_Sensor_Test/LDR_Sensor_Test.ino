int photocellPin = 0;     // the cell and 10K pulldown are connected to a0
int photocellReading;     // the analog reading from the sensor divider
int LEDpin = 10;          // connect Red LED to pin 11 (PWM pin)
int LEDbrightness;        //
void setup(void) {
  Serial.begin(9600);   
}
 
void loop(void) {
  StaticJsonBuffer<1024> jsonBuffer; //Buffer to contain JSON objects
  JsonObject& obj = jsonBuffer.createObject();
  
  photocellReading = analogRead(photocellPin);  
 
  Serial.print("Analog reading = ");
  Serial.println(photocellReading);  
 
  // LED gets brighter the darker it is at the sensor
  // that means we have to -invert- the reading from 0-1023 back to 1023-0
  photocellReading = 1023 - photocellReading;
  //now we have to map 0-1023 to 0-255 since thats the range analogWrite uses
  LEDbrightness = map(photocellReading, 0, 1023, 0, 255);
  analogWrite(LEDpin, LEDbrightness);

  obj["id"] = 2; 
  obj["value"] = LEDbrightness;
  obj.printTo(Serial); 
  Serial.println(); 
     
  delay(100);
}
