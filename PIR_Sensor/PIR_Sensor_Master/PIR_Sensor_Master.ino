int calibrationTime = 30;        
long unsigned int lowIn;         
long unsigned int pause = 5000;  
boolean lockLow = true;
boolean takeLowTime;  

int pirPin = 5;    //the digital pin connected to the PIR sensor's output
int ledPin = 13;

struct values{
  int ID;
  char Val;
};

void setup(){
  Serial.begin(9600);
  pinMode(pirPin, INPUT);
  pinMode(ledPin, OUTPUT);
  digitalWrite(pirPin, LOW);
  for(int i = 0; i < calibrationTime; i++){
    delay(1000);
  }
  delay(50);
}

void loop(){
  if(digitalRead(pirPin) == HIGH){
    values variable = {1,'H'};
    Serial.write((const uint8_t *)&variable, sizeof(variable));
    digitalWrite(ledPin, HIGH);
    delay(10000);
    values variable2 = {1,'L'};
    Serial.write((const uint8_t *)&variable2, sizeof(variable2));
    digitalWrite(ledPin, LOW);
  }
}

// void loop(){
//   delay(10000);
//   values variable = {1,'H'};
//   Serial.write((const uint8_t *)&variable, sizeof(variable));
//   digitalWrite(ledPin, HIGH);
//   delay(10000);
//   values variable2 = {1,'L'};
//   Serial.write((const uint8_t *)&variable2, sizeof(variable2));
//   digitalWrite(ledPin, LOW);
// }


// void loop(){
//     if(digitalRead(pirPin) == HIGH){
//       values variable = {1,'H'};
//       Serial.write((const uint8_t *)&variable, sizeof(variable));
//       digitalWrite(ledPin, HIGH);
//       delay(10000);
//       // if(lockLow){  
//       //   //makes sure we wait for a transition to LOW before any further output is made:
//       //   lockLow = false;            
//       //   delay(50);
//       //   }         
//       //   takeLowTime = true;
//       }

//     else if(digitalRead(pirPin) == LOW){
//     values variable2 = {1,'L'};
//     Serial.write((const uint8_t *)&variable2, sizeof(variable2));
//     digitalWrite(ledPin, LOW);
//     delay(10000);
//       // if(takeLowTime){
//       //   lowIn = millis();          //save the time of the transition from high to LOW
//       //   takeLowTime = false;       //make sure this is only done at the start of a LOW phase
//       //   }
//       // if(!lockLow && millis() - lowIn > pause){  
//       //     lockLow = true;   
//       //     }
//       }
//   }